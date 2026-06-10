import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

// Sesuaikan dengan environment:
// - Android Emulator : 'http://10.0.2.2:8000/api'
// - Physical Device  : 'http://192.168.x.x:8000/api' (IP LAN laptop)
// - iOS Simulator / Web / Desktop : 'http://127.0.0.1:8000/api'
String get _baseUrl {
  if (kIsWeb) return 'http://127.0.0.1:8000/api';
  // Default ke 10.0.2.2 untuk Android emulator
  return 'http://10.0.2.2:8000/api';
}

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Accept': 'application/json'},
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = ref.read(authTokenProvider);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (error, handler) {
      if (error.response?.statusCode == 401) {
        // BUG-17 fix: clear both token AND user data
        ref.invalidate(authTokenProvider);
        ref.invalidate(userDataProvider);
      }
      handler.next(error);
    },
  ));

  return dio;
}

@Riverpod(keepAlive: true)
class AuthToken extends _$AuthToken {
  @override
  String? build() => null;
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
