import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/widgets/serve_widgets.dart';
import 'package:serve_app/features/orders/domain/order_model.dart';
import '../order_list_provider.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<OrderModel> _filteredOrders(List<OrderModel> all, String? status) {
    if (status == null) return all;
    return all.where((o) => o.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(orderListNotifierProvider);
    
    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Pesanan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.go('/orders/create'),
            tooltip: 'Tambah Pesanan',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          dividerColor: ServeColors.border,
          indicatorColor: ServeColors.accentIndigo,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: ServeColors.accentIndigo,
          unselectedLabelColor: ServeColors.textMuted,
          labelStyle: ServeTypography.labelMedium(),
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Pending'),
            Tab(text: 'Diproses'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: ordersAsync.when(
        data: (orders) => TabBarView(
          controller: _tabController,
          children: [
            _OrderList(orders: _filteredOrders(orders, null)),
            _OrderList(orders: _filteredOrders(orders, 'pending')),
            _OrderList(orders: _filteredOrders(orders, 'preparing')),
            _OrderList(orders: _filteredOrders(orders, 'completed')),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Gagal memuat pesanan', style: ServeTypography.bodyMedium(color: ServeColors.danger)),
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<OrderModel> orders;

  const _OrderList({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const ServeEmptyState(
        icon: Icons.receipt_long_rounded,
        title: 'Belum ada pesanan',
        subtitle: 'Pesanan baru akan muncul di sini.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _OrderCard(order: orders[i]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  ServeBadge get _badge => switch (order.status) {
        'pending' => ServeBadge.pending(),
        'preparing' => ServeBadge.preparing(),
        'completed' => ServeBadge.completed(),
        'cancelled' => ServeBadge.cancelled(),
        _ => ServeBadge.pending(),
      };

  @override
  Widget build(BuildContext context) {
    return ServeCard(
      onTap: () => context.go('/orders/${order.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(order.customerName,
                    style: ServeTypography.h3(color: ServeColors.textPrimary)),
              ),
              _badge,
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.dining_rounded, size: 14, color: ServeColors.textMuted),
              const SizedBox(width: 4),
              Text(order.orderType,
                  style: ServeTypography.bodySmall(color: ServeColors.textSecondary)),
              if (order.tableNumber != null && order.tableNumber!.isNotEmpty) ...[
                const SizedBox(width: 12),
                Icon(Icons.table_restaurant_rounded, size: 14, color: ServeColors.textMuted),
                const SizedBox(width: 4),
                Text('Meja ${order.tableNumber}',
                    style: ServeTypography.bodySmall(color: ServeColors.textSecondary)),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(order.orderNumber,
                  style: ServeTypography.labelSmall(color: ServeColors.textMuted)),
              const Spacer(),
              Text(
                'Rp ${(order.totalAmount / 1000).toStringAsFixed(0)}rb',
                style: ServeTypography.labelMedium(color: ServeColors.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
