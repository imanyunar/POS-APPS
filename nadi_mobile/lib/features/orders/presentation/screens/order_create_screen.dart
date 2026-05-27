import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/utils/formatters.dart';
import 'package:serve_app/features/menu/presentation/menu_list_provider.dart';
import 'package:serve_app/features/orders/presentation/order_list_provider.dart';

class OrderCreateScreen extends ConsumerStatefulWidget {
  const OrderCreateScreen({super.key});

  @override
  ConsumerState<OrderCreateScreen> createState() => _OrderCreateScreenState();
}

class _OrderCreateScreenState extends ConsumerState<OrderCreateScreen> {
  String _orderType = 'dine-in';
  final _tableController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Cart: Map of menuItemId to quantity
  final Map<String, int> _cart = {};
  bool _isSubmitting = false;

  @override
  void dispose() {
    _tableController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateCart(String itemId, int delta) {
    setState(() {
      final current = _cart[itemId] ?? 0;
      final next = current + delta;
      if (next <= 0) {
        _cart.remove(itemId);
      } else {
        _cart[itemId] = next;
      }
    });
  }

  Future<void> _submitOrder(List<dynamic> menuItems) async {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang masih kosong'), backgroundColor: ServeColors.warning),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final itemsPayload = _cart.entries.map((entry) {
        final menu = menuItems.firstWhere((m) => m.id == entry.key);
        return {
          'menuItemId': menu.id,
          'name': menu.name,
          'quantity': entry.value,
          'unitPrice': menu.price,
        };
      }).toList();

      final payload = {
        'orderType': _orderType,
        'tableNumber': _tableController.text,
        'notes': _notesController.text,
        'items': itemsPayload,
      };

      await ref.read(orderListNotifierProvider.notifier).createOrder(payload);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil dibuat'), backgroundColor: ServeColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat pesanan: $e'), backgroundColor: ServeColors.danger),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuAsync = ref.watch(menuListNotifierProvider);

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Buat Pesanan'),
      ),
      body: menuAsync.when(
        data: (menuItems) {
          // Calculate total
          double totalAmount = 0;
          for (var entry in _cart.entries) {
            final menu = menuItems.firstWhere((m) => m.id == entry.key);
            totalAmount += menu.price * entry.value;
          }

          return Column(
            children: [
              // Order Type & Details
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(value: 'dine-in', label: Text('Dine In'), icon: Icon(Icons.restaurant_rounded)),
                              ButtonSegment(value: 'takeaway', label: Text('Takeaway'), icon: Icon(Icons.takeout_dining_rounded)),
                            ],
                            selected: {_orderType},
                            onSelectionChanged: (set) => setState(() => _orderType = set.first),
                          ),
                        ),
                      ],
                    ),
                    if (_orderType == 'dine-in') ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _tableController,
                        decoration: InputDecoration(
                          labelText: 'Nomor Meja',
                          hintText: 'Misal: 12',
                          isDense: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Catatan (opsional)',
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              
              // Menu List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    if (!item.isAvailable) return const SizedBox.shrink();

                    final qty = _cart[item.id] ?? 0;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ServeColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: ServeTypography.h3(color: ServeColors.textPrimary)),
                                Text(ServeFormatters.rupiah(item.price), style: ServeTypography.labelMedium(color: ServeColors.primary)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: qty > 0 ? () => _updateCart(item.id, -1) : null,
                                icon: const Icon(Icons.remove_circle_outline),
                                color: ServeColors.danger,
                              ),
                              Text('$qty', style: ServeTypography.h3(color: ServeColors.textPrimary)),
                              IconButton(
                                onPressed: () => _updateCart(item.id, 1),
                                icon: const Icon(Icons.add_circle_outline),
                                color: ServeColors.success,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Checkout Bar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Total Pesanan', style: ServeTypography.labelSmall(color: ServeColors.textMuted)),
                            Text(ServeFormatters.rupiah(totalAmount), style: ServeTypography.h2(color: ServeColors.primary)),
                          ],
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _isSubmitting ? null : () => _submitOrder(menuItems),
                        icon: _isSubmitting 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.check_circle_rounded),
                        label: const Text('Proses'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Gagal memuat menu: $err')),
      ),
    );
  }
}
