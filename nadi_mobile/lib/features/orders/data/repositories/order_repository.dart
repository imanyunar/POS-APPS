import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serve_app/core/network/dio_client.dart';
import 'package:serve_app/core/network/api_endpoints.dart';
import 'package:serve_app/features/orders/domain/order_model.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.watch(dioClientProvider));
});

class OrderRepository {
  final DioClient _client;

  OrderRepository(this._client);

  Future<List<OrderModel>> fetchOrders() async {
    final response = await _client.dio.get(ApiEndpoints.orders);
    final apiResponse = ApiResponse<List<OrderModel>>.fromJson(
      response.data,
      (data) => (data as List)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<OrderModel> fetchOrder(String id) async {
    final response = await _client.dio.get(ApiEndpoints.orderDetail(id));
    final apiResponse = ApiResponse<OrderModel>.fromJson(
      response.data,
      (data) => OrderModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<OrderModel> createOrder(Map<String, dynamic> data) async {
    final response = await _client.dio.post(ApiEndpoints.orders, data: data);
    final apiResponse = ApiResponse<OrderModel>.fromJson(
      response.data,
      (data) => OrderModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<OrderModel> updateOrderStatus(String id, String status) async {
    final response = await _client.dio.patch(
      ApiEndpoints.orderStatus(id),
      data: {'status': status},
    );
    final apiResponse = ApiResponse<OrderModel>.fromJson(
      response.data,
      (data) => OrderModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<OrderModel> updateOrder(String id, Map<String, dynamic> data) async {
    final response = await _client.dio.put(ApiEndpoints.orderDetail(id), data: data);
    final apiResponse = ApiResponse<OrderModel>.fromJson(
      response.data,
      (data) => OrderModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<void> deleteOrder(String id) async {
    final response = await _client.dio.delete(ApiEndpoints.orderDetail(id));
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.message);
    }
  }
}
