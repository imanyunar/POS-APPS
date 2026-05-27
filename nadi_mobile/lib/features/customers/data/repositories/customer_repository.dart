import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serve_app/core/network/dio_client.dart';
import 'package:serve_app/core/network/api_endpoints.dart';
import 'package:serve_app/features/customers/domain/customer_model.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(ref.watch(dioClientProvider));
});

class CustomerRepository {
  final DioClient _client;

  CustomerRepository(this._client);

  Future<List<CustomerModel>> fetchCustomers() async {
    final response = await _client.dio.get(ApiEndpoints.customers);
    final apiResponse = ApiResponse<List<CustomerModel>>.fromJson(
      response.data,
      (data) => (data as List)
          .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<CustomerModel> fetchCustomer(String id) async {
    final response = await _client.dio.get(ApiEndpoints.customerDetail(id));
    final apiResponse = ApiResponse<CustomerModel>.fromJson(
      response.data,
      (data) => CustomerModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<CustomerModel> createCustomer(Map<String, dynamic> data) async {
    final response = await _client.dio.post(ApiEndpoints.customers, data: data);
    final apiResponse = ApiResponse<CustomerModel>.fromJson(
      response.data,
      (data) => CustomerModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<CustomerModel> updateCustomer(String id, Map<String, dynamic> data) async {
    final response = await _client.dio.put(ApiEndpoints.customerDetail(id), data: data);
    final apiResponse = ApiResponse<CustomerModel>.fromJson(
      response.data,
      (data) => CustomerModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<void> deleteCustomer(String id) async {
    final response = await _client.dio.delete(ApiEndpoints.customerDetail(id));
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.message);
    }
  }
}
