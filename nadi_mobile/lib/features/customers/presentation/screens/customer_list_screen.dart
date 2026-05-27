import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/widgets/serve_widgets.dart';
import 'package:serve_app/core/utils/formatters.dart';
import 'package:serve_app/features/customers/domain/customer_model.dart';
import '../customer_list_provider.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customerListNotifierProvider);
    
    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Pelanggan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: () => context.go('/customers/create'),
            tooltip: 'Tambah Pelanggan',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              style: ServeTypography.bodyMedium(color: ServeColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Cari nama atau nomor HP...',
                prefixIcon: const Icon(Icons.search_rounded, color: ServeColors.textMuted),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                filled: true,
                fillColor: ServeColors.bgCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: customersAsync.when(
              data: (customers) {
                if (customers.isEmpty) {
                  return const ServeEmptyState(
                    icon: Icons.people_outline_rounded,
                    title: 'Belum ada pelanggan',
                    subtitle: 'Tambahkan data pelanggan pertama Anda.',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.read(customerListNotifierProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: customers.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _CustomerCard(customer: customers[index]);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Gagal memuat pelanggan', style: ServeTypography.bodyMedium(color: ServeColors.danger)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final CustomerModel customer;

  const _CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    return ServeCard(
      onTap: () => context.go('/customers/${customer.id}'),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ServeColors.accentIndigoBg,
            child: Text(
              customer.name.substring(0, 1).toUpperCase(),
              style: ServeTypography.labelMedium(color: ServeColors.accentIndigo),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer.name, style: ServeTypography.h3(color: ServeColors.textPrimary)),
                const SizedBox(height: 4),
                Text(customer.phone, style: ServeTypography.bodySmall(color: ServeColors.textSecondary)),
              ],
            ),
          ),
          if (customer.outstandingDebt > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Piutang', style: ServeTypography.labelSmall(color: ServeColors.warning)),
                Text(ServeFormatters.rupiahCompact(customer.outstandingDebt),
                    style: ServeTypography.labelMedium(color: ServeColors.textPrimary)),
              ],
            )
          else
            const Icon(Icons.chevron_right_rounded, color: ServeColors.textMuted),
        ],
      ),
    );
  }
}
