import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/widgets/serve_widgets.dart';
import 'package:serve_app/core/utils/formatters.dart';
import 'package:serve_app/features/menu/domain/menu_item_model.dart';
import '../menu_list_provider.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  Future<void> _deleteMenuItem(String id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Menu?'),
        content: Text('Apakah Anda yakin ingin menghapus "$name"? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Hapus', style: TextStyle(color: ServeColors.danger)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await ref.read(menuListNotifierProvider.notifier).deleteMenuItem(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Menu berhasil dihapus'), backgroundColor: ServeColors.success),
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
    final menuAsync = ref.watch(menuListNotifierProvider);

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.go('/more/menu/create'),
            tooltip: 'Tambah Menu',
          ),
        ],
      ),
      body: menuAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const ServeEmptyState(
              icon: Icons.restaurant_menu_rounded,
              title: 'Belum ada menu',
              subtitle: 'Tambahkan item menu pertama Anda.',
            );
          }

          // Group by category
          final grouped = <String, List<MenuItemModel>>{};
          for (final item in items) {
            grouped.putIfAbsent(item.category, () => []).add(item);
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(menuListNotifierProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 8),
                      child: Text(
                        entry.key.toUpperCase(),
                        style: ServeTypography.labelMedium(color: ServeColors.accentIndigo),
                      ),
                    ),
                    ...entry.value.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _MenuItemCard(
                        item: item,
                        onDelete: () => _deleteMenuItem(item.id, item.name),
                      ),
                    )),
                  ],
                );
              }).toList(),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Gagal memuat menu', style: ServeTypography.bodyMedium(color: ServeColors.danger)),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref.read(menuListNotifierProvider.notifier).refresh(),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItemModel item;
  final VoidCallback? onDelete;

  const _MenuItemCard({required this.item, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ServeCard(
      onTap: () => context.go('/more/menu/${item.id}/edit'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.isAvailable ? ServeColors.successBg : ServeColors.dangerBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.restaurant_rounded,
              color: item.isAvailable ? ServeColors.success : ServeColors.danger,
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
                    Text(
                      ServeFormatters.rupiah(item.price),
                      style: ServeTypography.labelMedium(color: ServeColors.textPrimary),
                    ),
                  ],
                ),
                if (item.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: ServeTypography.bodySmall(color: ServeColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 14, color: ServeColors.textMuted),
                    const SizedBox(width: 4),
                    Text('${item.estimatedPrepMinutes} min',
                      style: ServeTypography.labelSmall(color: ServeColors.textMuted)),
                    if (item.trackStock) ...[
                      const SizedBox(width: 16),
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 14,
                        color: item.stockQuantity <= item.lowStockThreshold
                            ? ServeColors.danger
                            : ServeColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Stok: ${item.stockQuantity}',
                        style: ServeTypography.labelSmall(
                          color: item.stockQuantity <= item.lowStockThreshold
                              ? ServeColors.danger
                              : ServeColors.textMuted,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (!item.isAvailable)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: ServeColors.dangerBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Non-aktif', style: ServeTypography.labelSmall(color: ServeColors.danger)),
                      ),
                    if (onDelete != null) ...[
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(Icons.delete_outline_rounded, size: 18, color: ServeColors.textMuted),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
