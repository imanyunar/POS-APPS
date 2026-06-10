import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api_client.dart';

part 'dashboard_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> dashboardSummary(Ref ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('/dashboard/summary');
  return response.data as Map<String, dynamic>;
}
