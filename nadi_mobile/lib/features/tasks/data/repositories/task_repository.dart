import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serve_app/core/network/dio_client.dart';
import 'package:serve_app/core/network/api_endpoints.dart';
import 'package:serve_app/features/tasks/domain/task_model.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.watch(dioClientProvider));
});

class TaskRepository {
  final DioClient _client;

  TaskRepository(this._client);

  Future<List<TaskModel>> fetchTasks() async {
    final response = await _client.dio.get(ApiEndpoints.tasks);
    final apiResponse = ApiResponse<List<TaskModel>>.fromJson(
      response.data,
      (data) => (data as List)
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<TaskModel> createTask(Map<String, dynamic> data) async {
    final response = await _client.dio.post(ApiEndpoints.tasks, data: data);
    final apiResponse = ApiResponse<TaskModel>.fromJson(
      response.data,
      (data) => TaskModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<TaskModel> updateTask(String id, Map<String, dynamic> data) async {
    final response = await _client.dio.put(ApiEndpoints.taskDetail(id), data: data);
    final apiResponse = ApiResponse<TaskModel>.fromJson(
      response.data,
      (data) => TaskModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<void> deleteTask(String id) async {
    final response = await _client.dio.delete(ApiEndpoints.taskDetail(id));
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.message);
    }
  }

  Future<TaskModel> toggleTask(String id) async {
    final response = await _client.dio.patch(ApiEndpoints.taskToggle(id));
    final apiResponse = ApiResponse<TaskModel>.fromJson(
      response.data,
      (data) => TaskModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }
}
