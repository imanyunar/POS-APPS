import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/utils/formatters.dart';
import 'package:serve_app/core/widgets/serve_widgets.dart';
import 'package:serve_app/features/invoices/presentation/invoice_detail_provider.dart';
import 'package:serve_app/features/invoices/presentation/invoice_list_provider.dart';

class InvoiceDetailScreen extends ConsumerStatefulWidget {
  final String invoiceId;
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  ConsumerState<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends ConsumerState<InvoiceDetailScreen> {
  Future<void> _markAsPaid() async {
    try {
      await ref.read(invoiceListNotifierProvider.notifier).markPaid(widget.invoiceId);
      ref.invalidate(invoiceDetailProvider(widget.invoiceId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tagihan ditandai Lunas'), backgroundColor: ServeColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui status: $e'), backgroundColor: ServeColors.danger),
        );
      }
    }
  }

  Future<void> _deleteInvoice() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tagihan?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Hapus', style: TextStyle(color: ServeColors.danger))
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await ref.read(invoiceListNotifierProvider.notifier).deleteInvoice(widget.invoiceId);
        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tagihan dihapus'), backgroundColor: ServeColors.success),
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
    final invoiceAsync = ref.watch(invoiceDetailProvider(widget.invoiceId));

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Detail Tagihan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: ServeColors.danger),
            onPressed: _deleteInvoice,
            tooltip: 'Hapus',
          ),
        ],
      ),
      body: invoiceAsync.when(
        data: (invoice) {
          final bool isUnpaid = invoice.status == 'unpaid' || invoice.status == 'overdue';

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(invoiceDetailProvider(widget.invoiceId)),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Header Status
                Center(
                  child: Column(
                    children: [
                      Text(invoice.invoiceNumber, style: ServeTypography.h2(color: ServeColors.textPrimary)),
                      const SizedBox(height: 8),
                      ServeBadge(
                        label: invoice.status.toUpperCase(),
                        color: invoice.status == 'paid' ? ServeColors.success : ServeColors.warning,
                        backgroundColor: invoice.status == 'paid' ? ServeColors.successBg : ServeColors.warningBg,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Invoice Info
                ServeCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Informasi Tagihan', style: ServeTypography.h3(color: ServeColors.textPrimary)),
                      const SizedBox(height: 16),
                      _InfoRow(icon: Icons.person_rounded, label: 'Pelanggan', value: invoice.customerName.isEmpty ? 'Umum' : invoice.customerName),
                      const Divider(),
                      _InfoRow(icon: Icons.receipt_long_rounded, label: 'Subtotal', value: ServeFormatters.rupiah(invoice.subtotal)),
                      const Divider(),
                      _InfoRow(icon: Icons.percent_rounded, label: 'Pajak', value: ServeFormatters.rupiah(invoice.tax)),
                      const Divider(),
                      _InfoRow(icon: Icons.paid_rounded, label: 'Total', value: ServeFormatters.rupiah(invoice.total), isTotal: true),
                    ],
                  ),
                ),

                if (isUnpaid) ...[
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: _markAsPaid,
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Tandai Lunas'),
                    style: FilledButton.styleFrom(
                      backgroundColor: ServeColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Gagal memuat detail: $err')),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isTotal;

  const _InfoRow({required this.icon, required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ServeColors.textMuted),
          const SizedBox(width: 12),
          Text(label, style: ServeTypography.bodyMedium(color: ServeColors.textSecondary)),
          const Spacer(),
          Text(
            value,
            style: isTotal 
                ? ServeTypography.h3(color: ServeColors.primary)
                : ServeTypography.bodyMedium(color: ServeColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
