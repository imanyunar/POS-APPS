import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/activity_repository.dart';
import '../domain/activity_model.dart';

part 'activity_list_provider.g.dart';

@riverpod
class ActivityListNotifier extends _$ActivityListNotifier {
  @override
  FutureOr<List<ActivityModel>> build() async {
    return ref.read(activityRepositoryProvider).fetchActivities();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(activityRepositoryProvider).fetchActivities(),
    );
  }
}
