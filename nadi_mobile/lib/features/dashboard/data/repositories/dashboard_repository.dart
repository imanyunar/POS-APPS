import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serve_app/core/network/dio_client.dart';
import 'package:serve_app/core/network/api_endpoints.dart';
import 'package:serve_app/features/dashboard/domain/dashboard_vitals.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DashboardRepository(dioClient);
});

class DashboardRepository {
  final DioClient _client;

  DashboardRepository(this._client);

  Future<DashboardVitals> fetchVitals() async {
    try {
      final response = await _client.dio.get(ApiEndpoints.dashboardVitals);
      final apiResponse = ApiResponse<DashboardVitals>.fromJson(
        response.data,
        (json) => DashboardVitals.fromJson(json as Map<String, dynamic>),
      );
      
      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      }
      throw Exception(apiResponse.message);
    } catch (e) {
      rethrow;
    }
  }
}
