import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/order_repository.dart';
import '../domain/order_model.dart';

final orderDetailProvider = FutureProvider.autoDispose.family<OrderModel, String>((ref, id) async {
  return ref.watch(orderRepositoryProvider).fetchOrder(id);
});
