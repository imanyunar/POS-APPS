import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/inventory_repository.dart';
import '../domain/inventory_model.dart';

part 'inventory_list_provider.g.dart';

@riverpod
class InventoryListNotifier extends _$InventoryListNotifier {
  @override
  FutureOr<List<InventoryModel>> build() async {
    return ref.read(inventoryRepositoryProvider).fetchInventory();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(inventoryRepositoryProvider).fetchInventory(),
    );
  }

  Future<void> createInventoryItem(Map<String, dynamic> data) async {
    await ref.read(inventoryRepositoryProvider).createInventoryItem(data);
    await refresh();
  }

  Future<void> updateInventoryItem(String id, Map<String, dynamic> data) async {
    await ref.read(inventoryRepositoryProvider).updateInventoryItem(id, data);
    await refresh();
  }

  Future<void> deleteInventoryItem(String id) async {
    await ref.read(inventoryRepositoryProvider).deleteInventoryItem(id);
    await refresh();
  }
}
