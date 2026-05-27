import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/customer_repository.dart';
import '../domain/customer_model.dart';

part 'customer_list_provider.g.dart';

@riverpod
class CustomerListNotifier extends _$CustomerListNotifier {
  @override
  FutureOr<List<CustomerModel>> build() async {
    return ref.read(customerRepositoryProvider).fetchCustomers();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(customerRepositoryProvider).fetchCustomers(),
    );
  }

  Future<void> createCustomer(Map<String, dynamic> data) async {
    await ref.read(customerRepositoryProvider).createCustomer(data);
    await refresh();
  }

  Future<void> updateCustomer(String id, Map<String, dynamic> data) async {
    await ref.read(customerRepositoryProvider).updateCustomer(id, data);
    await refresh();
  }

  Future<void> deleteCustomer(String id) async {
    await ref.read(customerRepositoryProvider).deleteCustomer(id);
    await refresh();
  }
}
