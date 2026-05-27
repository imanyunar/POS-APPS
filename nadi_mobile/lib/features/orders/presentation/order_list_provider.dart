import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/order_repository.dart';
import '../domain/order_model.dart';

part 'order_list_provider.g.dart';

@riverpod
class OrderListNotifier extends _$OrderListNotifier {
  @override
  FutureOr<List<OrderModel>> build() async {
    return ref.read(orderRepositoryProvider).fetchOrders();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(orderRepositoryProvider).fetchOrders(),
    );
  }

  Future<void> createOrder(Map<String, dynamic> data) async {
    await ref.read(orderRepositoryProvider).createOrder(data);
    await refresh();
  }

  Future<void> updateOrderStatus(String id, String status) async {
    final previousState = state;
    if (state.value != null) {
      state = AsyncValue.data(
        state.value!.map((o) => o.id == id ? o.copyWith(status: status) : o).toList(),
      );
    }
    try {
      await ref.read(orderRepositoryProvider).updateOrderStatus(id, status);
    } catch (e) {
      state = previousState;
    }
  }
}
