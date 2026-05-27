import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/customer_repository.dart';
import '../domain/customer_model.dart';

final customerDetailProvider = FutureProvider.autoDispose.family<CustomerModel, String>((ref, id) async {
  return ref.watch(customerRepositoryProvider).fetchCustomer(id);
});
