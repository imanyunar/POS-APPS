import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/utils/formatters.dart';
import 'package:serve_app/core/widgets/serve_widgets.dart';
import 'package:serve_app/features/customers/presentation/customer_detail_provider.dart';
import 'package:serve_app/features/customers/presentation/customer_list_provider.dart';

class CustomerDetailScreen extends ConsumerStatefulWidget {
  final String customerId;
  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  ConsumerState<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends ConsumerState<CustomerDetailScreen> {
  Future<void> _deleteCustomer(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pelanggan?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: ServeColors.danger)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await ref.read(customerListNotifierProvider.notifier).deleteCustomer(widget.customerId);
        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pelanggan dihapus'), backgroundColor: ServeColors.success),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: ServeColors.danger),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerAsync = ref.watch(customerDetailProvider(widget.customerId));

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Detail Pelanggan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => context.go('/customers/${widget.customerId}/edit'),
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: ServeColors.danger),
            onPressed: () => _deleteCustomer(context),
            tooltip: 'Hapus',
          ),
        ],
      ),
      body: customerAsync.when(
        data: (customer) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(customerDetailProvider(widget.customerId));
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: ServeColors.accentIndigoBg,
                        child: Text(
                          customer.name.substring(0, 1).toUpperCase(),
                          style: ServeTypography.h1(color: ServeColors.accentIndigo),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(customer.name, style: ServeTypography.h2(color: ServeColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(customer.phone, style: ServeTypography.bodyMedium(color: ServeColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Metrics
                Row(
                  children: [
                    Expanded(
                      child: ServeCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text('Total Pesanan', style: ServeTypography.labelSmall(color: ServeColors.textMuted)),
                            const SizedBox(height: 8),
                            Text(
                              '${customer.ordersCount}',
                              style: ServeTypography.h2(color: ServeColors.accentIndigo),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ServeCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text('Piutang', style: ServeTypography.labelSmall(color: ServeColors.textMuted)),
                            const SizedBox(height: 8),
                            Text(
                              ServeFormatters.rupiahCompact(customer.outstandingDebt),
                              style: ServeTypography.h2(
                                color: customer.outstandingDebt > 0 ? ServeColors.danger : ServeColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Transaction History (Placeholder for now)
                Text('Riwayat Transaksi Terakhir', style: ServeTypography.h3(color: ServeColors.textPrimary)),
                const SizedBox(height: 12),
                ServeEmptyState(
                  icon: Icons.history_rounded,
                  title: 'Riwayat Transaksi',
                  subtitle: 'Riwayat pesanan dan tagihan pelanggan akan muncul di sini.',
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Gagal memuat detail', style: ServeTypography.bodyMedium(color: ServeColors.danger)),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(customerDetailProvider(widget.customerId)),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
