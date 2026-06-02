import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/widgets/serve_widgets.dart';
import 'package:serve_app/core/utils/formatters.dart';
import 'package:serve_app/features/inventory/domain/inventory_model.dart';
import '../inventory_list_provider.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(inventoryListNotifierProvider);

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Inventaris'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              style: ServeTypography.bodyMedium(color: ServeColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Cari barang (SKU, Nama)...',
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
            child: inventoryAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const ServeEmptyState(
                    icon: Icons.inventory_2_rounded,
                    title: 'Inventaris kosong',
                    subtitle: 'Kelola stok barang Anda dengan mudah.',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.read(inventoryListNotifierProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _InventoryCard(item: items[index]);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Gagal memuat inventaris', style: ServeTypography.bodyMedium(color: ServeColors.danger)),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/more/inventory/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  final InventoryModel item;

  const _InventoryCard({required this.item});

  bool get _isCritical => item.status == 'out_of_stock' || (item.status == 'low_stock' && item.quantity <= 3);
  bool get _isWarning => item.status == 'low_stock';

  ServeBadge get _badge => switch (item.status) {
        'in_stock' => ServeBadge.completed().copyWith(label: 'Tersedia'),
        'low_stock' => ServeBadge.unpaid().copyWith(label: 'Stok Menipis'),
        'out_of_stock' => ServeBadge.cancelled().copyWith(label: 'Habis'),
        _ => ServeBadge.pending(),
      };

  Color get _glowColor => item.status == 'out_of_stock'
      ? ServeColors.danger.withValues(alpha: 0.15)
      : ServeColors.warning.withValues(alpha: 0.12);

  @override
  Widget build(BuildContext context) {
    final bool showGlow = _isCritical || _isWarning;

    return Container(
      decoration: showGlow
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _glowColor,
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : null,
      child: ServeCard(
        onTap: () => context.go('/more/inventory/${item.id}/edit'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: showGlow
                    ? (_isCritical ? ServeColors.dangerBg : ServeColors.warningBg)
                    : ServeColors.accentIndigoBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isCritical
                    ? Icons.warning_rounded
                    : Icons.inventory_2_outlined,
                color: showGlow
                    ? (_isCritical ? ServeColors.danger : ServeColors.warning)
                    : ServeColors.accentIndigo,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(item.name, style: ServeTypography.h3(color: ServeColors.textPrimary)),
                      ),
                      const SizedBox(width: 8),
                      _badge,
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('SKU: ${item.sku}', style: ServeTypography.labelSmall(color: ServeColors.textSecondary)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Stok', style: ServeTypography.labelSmall(color: ServeColors.textMuted)),
                          Text(
                            '${item.quantity}',
                            style: ServeTypography.labelLarge(
                              color: _isCritical
                                  ? ServeColors.danger
                                  : _isWarning
                                      ? ServeColors.warning
                                      : ServeColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Harga', style: ServeTypography.labelSmall(color: ServeColors.textMuted)),
                          Text(ServeFormatters.rupiah(item.unitPrice), style: ServeTypography.labelLarge(color: ServeColors.textPrimary)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
