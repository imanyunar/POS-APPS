import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../providers/pos_provider.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // BUG-03 fix: cartProvider bukan cartProvider
    final cart = ref.watch(cartProvider);
    final productsAsync = ref.watch(posProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('POS / Kasir'),
        actions: [
          if (cart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () =>
                  ref.read(cartProvider.notifier).clear(),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari produk...',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                Expanded(
                  child: productsAsync.when(
                    data: (products) {
                      final filtered = _searchController.text.isEmpty
                          ? products
                          : products
                              .where((p) =>
                                  (p['name'] as String)
                                      .toLowerCase()
                                      .contains(
                                          _searchController.text.toLowerCase()) ||
                                  (p['sku'] ?? '')
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                          _searchController.text.toLowerCase()))
                              .toList();

                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final product = filtered[index];
                          // BUG-12 fix: gunakan num bukan int untuk cast aman
                          final isLowStock = (product['stock'] as num) <=
                              (product['min_stock'] as num);
                          final price =
                              'Rp ${((product['price'] as num).toInt()).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

                          return Card(
                            child: InkWell(
                              onTap: () {
                                // BUG-03 fix: cartProvider
                                ref.read(cartProvider.notifier).addItem(
                                      CartItem(
                                        productId: product['id'] as int,
                                        name: product['name'] as String,
                                        price: (product['price'] as num).toInt(),
                                      ),
                                    );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.inventory_2,
                                        size: 32,
                                        color: isLowStock
                                            ? AppColors.lowStock
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary),
                                    const SizedBox(height: 4),
                                    Text(
                                      product['name'] ?? '',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      price,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    Text(
                                      'Stok: ${product['stock']}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isLowStock
                                            ? AppColors.warning
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  child: Row(
                    children: [
                      Text('Keranjang',
                          style: Theme.of(context).textTheme.titleMedium),
                      const Spacer(),
                      Text('${cart.fold<int>(0, (sum, item) => sum + item.qty)} item'),
                    ],
                  ),
                ),
                Expanded(
                  child: cart.isEmpty
                      ? Center(
                          child: Text('Belum ada item',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant)))
                      : ListView.builder(
                          itemCount: cart.length,
                          itemBuilder: (context, index) {
                            final item = cart[index];
                            return Dismissible(
                              key: ValueKey(item.productId),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => ref
                                  .read(cartProvider.notifier)
                                  .removeItem(index),
                              child: ListTile(
                                dense: true,
                                title: Text(item.name),
                                subtitle: Text(
                                    'Rp ${(item.price).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} x ${item.qty}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle,
                                          size: 20),
                                      onPressed: () => ref
                                          .read(cartProvider.notifier)
                                          .updateQty(index, item.qty - 1),
                                    ),
                                    Text('${item.qty}'),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle,
                                          size: 20),
                                      onPressed: () => ref
                                          .read(cartProvider.notifier)
                                          .updateQty(index, item.qty + 1),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant)),
                          Text(
                            'Rp ${cart.fold<int>(0, (sum, item) => sum + item.subtotal).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 150,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: cart.isEmpty
                              ? null
                              : () => context.push('/payment'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: const Text('Bayar',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
