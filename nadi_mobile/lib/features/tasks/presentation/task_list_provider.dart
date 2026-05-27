import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/task_repository.dart';
import '../domain/task_model.dart';

part 'task_list_provider.g.dart';

@riverpod
class TaskListNotifier extends _$TaskListNotifier {
  @override
  FutureOr<List<TaskModel>> build() async {
    return ref.read(taskRepositoryProvider).fetchTasks();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(taskRepositoryProvider).fetchTasks(),
    );
  }

  Future<void> createTask(Map<String, dynamic> data) async {
    await ref.read(taskRepositoryProvider).createTask(data);
    await refresh();
  }

  Future<void> updateTask(String id, Map<String, dynamic> data) async {
    await ref.read(taskRepositoryProvider).updateTask(id, data);
    await refresh();
  }

  Future<void> deleteTask(String id) async {
    await ref.read(taskRepositoryProvider).deleteTask(id);
    await refresh();
  }

  Future<void> toggleTask(String id, bool currentStatus) async {
    final previousState = state;
    if (state.value != null) {
      state = AsyncValue.data(
        state.value!.map((t) => t.id == id ? t.copyWith(isCompleted: !currentStatus) : t).toList(),
      );
    }
    try {
      await ref.read(taskRepositoryProvider).toggleTask(id);
    } catch (e) {
      state = previousState;
    }
  }
}
