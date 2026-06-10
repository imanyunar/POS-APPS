import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api_client.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> login(String email, String password) async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final data = response.data;
      ref.read(authTokenProvider.notifier).state = data['token'] as String;
      ref.read(userDataProvider.notifier).state = data['user'];
      return true;
    } on DioException catch (e) {
      // BUG-01 fix: Laravel ValidationException (422) pakai format 'errors', bukan 'message'
      final data = e.response?.data;
      String msg = 'Login gagal';
      if (data is Map) {
        if (data['message'] != null) {
          msg = data['message'].toString();
        } else if (data['errors'] is Map) {
          final errors = data['errors'] as Map;
          final firstVal = errors.values.first;
          msg = firstVal is List ? firstVal.first.toString() : firstVal.toString();
        }
      }
      throw ApiException(msg);
    }
  }

  Future<bool> register(
      String name, String email, String password, String workspaceName) async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'workspace_name': workspaceName,
      });

      final data = response.data;
      ref.read(authTokenProvider.notifier).state = data['token'] as String;
      ref.read(userDataProvider.notifier).state = data['user'];
      return true;
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Registrasi gagal';
      throw ApiException(msg);
    }
  }

  Future<void> logout() async {
    try {
      final dio = ref.read(dioProvider);
      await dio.post('/auth/logout');
    } catch (_) {}
    ref.read(authTokenProvider.notifier).state = null;
    ref.read(userDataProvider.notifier).state = null;
  }

  Future<void> fetchMe() async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('/auth/me');
      ref.read(userDataProvider.notifier).state = response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        ref.read(authTokenProvider.notifier).state = null;
      }
    }
  }
}

@riverpod
class UserData extends _$UserData {
  @override
  Map<String, dynamic>? build() => null;
}
