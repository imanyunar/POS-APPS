import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serve_app/core/network/dio_client.dart';
import 'package:serve_app/core/network/api_endpoints.dart';
import 'package:serve_app/features/menu/domain/menu_item_model.dart';

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  return MenuRepository(ref.watch(dioClientProvider));
});

class MenuRepository {
  final DioClient _client;

  MenuRepository(this._client);

  Future<List<MenuItemModel>> fetchMenuItems() async {
    final response = await _client.dio.get(ApiEndpoints.menuItems);
    final apiResponse = ApiResponse<List<MenuItemModel>>.fromJson(
      response.data,
      (data) => (data as List)
          .map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<MenuItemModel> createMenuItem(Map<String, dynamic> data) async {
    final response = await _client.dio.post(ApiEndpoints.menuItems, data: data);
    final apiResponse = ApiResponse<MenuItemModel>.fromJson(
      response.data,
      (data) => MenuItemModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<MenuItemModel> updateMenuItem(String id, Map<String, dynamic> data) async {
    final response = await _client.dio.put(ApiEndpoints.menuItemDetail(id), data: data);
    final apiResponse = ApiResponse<MenuItemModel>.fromJson(
      response.data,
      (data) => MenuItemModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<MenuItemModel> toggleAvailability(String id) async {
    final response = await _client.dio.patch(ApiEndpoints.menuItemToggleAvailability(id));
    final apiResponse = ApiResponse<MenuItemModel>.fromJson(
      response.data,
      (data) => MenuItemModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<void> deleteMenuItem(String id) async {
    final response = await _client.dio.delete(ApiEndpoints.menuItemDetail(id));
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.message);
    }
  }
}
