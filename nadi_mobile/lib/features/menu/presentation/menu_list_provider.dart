import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/menu_repository.dart';
import '../domain/menu_item_model.dart';

part 'menu_list_provider.g.dart';

@riverpod
class MenuListNotifier extends _$MenuListNotifier {
  @override
  FutureOr<List<MenuItemModel>> build() async {
    return ref.read(menuRepositoryProvider).fetchMenuItems();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(menuRepositoryProvider).fetchMenuItems(),
    );
  }

  Future<void> createMenuItem(Map<String, dynamic> data) async {
    await ref.read(menuRepositoryProvider).createMenuItem(data);
    await refresh();
  }

  Future<void> updateMenuItem(String id, Map<String, dynamic> data) async {
    await ref.read(menuRepositoryProvider).updateMenuItem(id, data);
    await refresh();
  }

  Future<void> toggleAvailability(String id) async {
    await ref.read(menuRepositoryProvider).toggleAvailability(id);
    await refresh();
  }

  Future<void> deleteMenuItem(String id) async {
    await ref.read(menuRepositoryProvider).deleteMenuItem(id);
    await refresh();
  }
}
