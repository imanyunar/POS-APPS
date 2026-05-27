import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serve_app/core/network/dio_client.dart';
import 'package:serve_app/core/network/api_endpoints.dart';
import 'package:serve_app/features/invoices/domain/invoice_model.dart';

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository(ref.watch(dioClientProvider));
});

class InvoiceRepository {
  final DioClient _client;

  InvoiceRepository(this._client);

  Future<List<InvoiceModel>> fetchInvoices() async {
    final response = await _client.dio.get(ApiEndpoints.invoices);
    final apiResponse = ApiResponse<List<InvoiceModel>>.fromJson(
      response.data,
      (data) => (data as List)
          .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<InvoiceModel> fetchInvoice(String id) async {
    final response = await _client.dio.get(ApiEndpoints.invoiceDetail(id));
    final apiResponse = ApiResponse<InvoiceModel>.fromJson(
      response.data,
      (data) => InvoiceModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<InvoiceModel> createInvoice(Map<String, dynamic> data) async {
    final response = await _client.dio.post(ApiEndpoints.invoices, data: data);
    final apiResponse = ApiResponse<InvoiceModel>.fromJson(
      response.data,
      (data) => InvoiceModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<InvoiceModel> markPaid(String id) async {
    final response = await _client.dio.patch(ApiEndpoints.invoiceMarkPaid(id));
    final apiResponse = ApiResponse<InvoiceModel>.fromJson(
      response.data,
      (data) => InvoiceModel.fromJson(data as Map<String, dynamic>),
    );
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.message);
  }

  Future<void> deleteInvoice(String id) async {
    final response = await _client.dio.delete(ApiEndpoints.invoiceDetail(id));
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.message);
    }
  }
}
