import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/dashboard_repository.dart';
import '../domain/dashboard_vitals.dart';

part 'dashboard_vitals_provider.g.dart';

@riverpod
class DashboardVitalsNotifier extends _$DashboardVitalsNotifier {
  @override
  FutureOr<DashboardVitals> build() async {
    return _fetchVitals();
  }

  Future<DashboardVitals> _fetchVitals() async {
    final repository = ref.read(dashboardRepositoryProvider);
    return repository.fetchVitals();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchVitals());
  }
}
