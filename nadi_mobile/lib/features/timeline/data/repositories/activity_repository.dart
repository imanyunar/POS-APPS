import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serve_app/core/network/dio_client.dart';
import 'package:serve_app/core/network/api_endpoints.dart';
import 'package:serve_app/features/timeline/domain/activity_model.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepository(ref.watch(dioClientProvider));
});

class ActivityRepository {
  final DioClient _client;

  ActivityRepository(this._client);

  Future<List<ActivityModel>> fetchActivities() async {
    final response = await _client.dio.get(ApiEndpoints.activities);

    final apiResponse = ApiResponse<List<ActivityModel>>.fromJson(
      response.data,
      (data) => (data as List)
          .map((e) => ActivityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }
}
