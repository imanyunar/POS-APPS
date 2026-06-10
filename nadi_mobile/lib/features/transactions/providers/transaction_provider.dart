import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api_client.dart';

part 'transaction_provider.g.dart';

@riverpod
Future<List<Map<String, dynamic>>> transactionList(
    Ref ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('/transactions', queryParameters: {
    'per_page': 50,
  });
  final data = response.data;
  return (data['data'] as List).cast<Map<String, dynamic>>();
}

@riverpod
Future<Map<String, dynamic>> transactionDetail(
    Ref ref, int id) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('/transactions/$id');
  return response.data as Map<String, dynamic>;
}
