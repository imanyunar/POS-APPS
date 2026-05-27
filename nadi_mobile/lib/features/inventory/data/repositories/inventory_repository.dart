import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serve_app/core/network/dio_client.dart';
import 'package:serve_app/core/network/api_endpoints.dart';
import 'package:serve_app/features/inventory/domain/inventory_model.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(ref.watch(dioClientProvider));
});

class InventoryRepository {
  final DioClient _client;

  InventoryRepository(this._client);

  Future<List<InventoryModel>> fetchInventory() async {
    final response = await _client.dio.get(ApiEndpoints.inventory);
    final apiResponse = ApiResponse<List<InventoryModel>>.fromJson(
      response.data,
      (data) => (data as List)
          .map((e) => InventoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<InventoryModel> createInventoryItem(Map<String, dynamic> data) async {
    final response = await _client.dio.post(ApiEndpoints.inventory, data: data);
    final apiResponse = ApiResponse<InventoryModel>.fromJson(
      response.data,
      (data) => InventoryModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<InventoryModel> updateInventoryItem(String id, Map<String, dynamic> data) async {
    final response = await _client.dio.put(ApiEndpoints.inventoryDetail(id), data: data);
    final apiResponse = ApiResponse<InventoryModel>.fromJson(
      response.data,
      (data) => InventoryModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<void> deleteInventoryItem(String id) async {
    final response = await _client.dio.delete(ApiEndpoints.inventoryDetail(id));
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.message);
    }
  }
}
