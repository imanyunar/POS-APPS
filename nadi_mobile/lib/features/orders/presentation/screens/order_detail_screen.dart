import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/utils/formatters.dart';
import 'package:serve_app/core/widgets/serve_widgets.dart';
import 'package:serve_app/features/orders/presentation/order_detail_provider.dart';
import 'package:serve_app/features/orders/presentation/order_list_provider.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  Future<bool> _deleteOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pesanan?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
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
        await ref.read(orderListNotifierProvider.notifier).deleteOrder(widget.orderId);
        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pesanan dihapus'), backgroundColor: ServeColors.success),
          );
        }
        return true;
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: ServeColors.danger),
          );
        }
      }
    }
    return false;
  }

  Future<void> _updateStatus(String currentStatus, String newStatus) async {
    if (currentStatus == newStatus) return;

    try {
      await ref.read(orderListNotifierProvider.notifier).updateOrderStatus(widget.orderId, newStatus);
      ref.invalidate(orderDetailProvider(widget.orderId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status diubah ke $newStatus'), backgroundColor: ServeColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengubah status: $e'), backgroundColor: ServeColors.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(orderDetailProvider(widget.orderId));

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => context.go('/orders/${widget.orderId}/edit'),
            tooltip: 'Edit Pesanan',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: ServeColors.danger),
            onPressed: _deleteOrder,
            tooltip: 'Hapus Pesanan',
          ),
        ],
      ),
      body: orderAsync.when(
        data: (order) {
          final isDineIn = order.orderType == 'dine-in';
          
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(orderDetailProvider(widget.orderId)),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Header Status
                Center(
                  child: Column(
                    children: [
                      Text(order.orderNumber, style: ServeTypography.h2(color: ServeColors.textPrimary)),
                      const SizedBox(height: 8),
                      DropdownMenu<String>(
                        initialSelection: order.status,
                        onSelected: (val) {
                          if (val != null) _updateStatus(order.status, val);
                        },
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'pending', label: 'Pending'),
                          DropdownMenuEntry(value: 'preparing', label: 'Preparing'),
                          DropdownMenuEntry(value: 'ready', label: 'Ready'),
                          DropdownMenuEntry(value: 'completed', label: 'Completed'),
                          DropdownMenuEntry(value: 'cancelled', label: 'Cancelled'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Order Info
                ServeCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Informasi Pesanan', style: ServeTypography.h3(color: ServeColors.textPrimary)),
                      const SizedBox(height: 16),
                      _InfoRow(icon: Icons.person_rounded, label: 'Pelanggan', value: order.customerName.isEmpty ? 'Umum' : order.customerName),
                      const Divider(),
                      _InfoRow(
                        icon: isDineIn ? Icons.restaurant_rounded : Icons.takeout_dining_rounded, 
                        label: 'Tipe', 
                        value: order.orderType,
                      ),
                      if (isDineIn && order.tableNumber != null) ...[
                        const Divider(),
                        _InfoRow(icon: Icons.table_restaurant_rounded, label: 'Meja', value: order.tableNumber!),
                      ],
                      if (order.notes.isNotEmpty) ...[
                        const Divider(),
                        _InfoRow(icon: Icons.note_rounded, label: 'Catatan', value: order.notes),
                      ],
                      const Divider(),
                      _InfoRow(icon: Icons.paid_rounded, label: 'Total', value: ServeFormatters.rupiah(order.totalAmount), isTotal: true),
                    ],
                  ),
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
                onPressed: () => ref.invalidate(orderDetailProvider(widget.orderId)),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
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
