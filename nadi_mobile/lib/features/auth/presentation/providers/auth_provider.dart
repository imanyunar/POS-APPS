import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serve_app/features/auth/data/repositories/auth_repository.dart';
import 'package:serve_app/features/auth/domain/user_model.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.uninitialized,
    this.user,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }

  bool hasPermission(String permission) => user?.hasPermission(permission) ?? false;
  bool hasRole(String role) => user?.hasRole(role) ?? false;
  bool get isAuthenticated => status == AuthStatus.authenticated;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState()) {
    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    try {
      final hasToken = await _repository.isAuthenticated();
      if (hasToken) {
        final user = await _repository.fetchMe();
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (_) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final result = await _repository.login(email, password);
      state = AuthState(status: AuthStatus.authenticated, user: result.user);
    } catch (e) {
      final msg = _extractError(e);
      state = state.copyWith(status: AuthStatus.unauthenticated, error: msg);
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final result = await _repository.register(name, email, password);
      state = AuthState(status: AuthStatus.authenticated, user: result.user);
    } catch (e) {
      final msg = _extractError(e);
      state = state.copyWith(status: AuthStatus.unauthenticated, error: msg);
    }
  }

  Future<void> switchWorkspace(String workspaceId) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final partialUser = await _repository.switchWorkspace(workspaceId);
      final currentUser = state.user;
      if (currentUser != null) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: currentUser.copyWith(
            roles: partialUser.roles,
            permissions: partialUser.permissions,
            currentWorkspaceId: workspaceId,
          ),
        );
      }
    } catch (e) {
      state = state.copyWith(error: _extractError(e));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String _extractError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'] as String;
      }
      if (e.response?.statusCode == 422) {
        final errors = data is Map ? data['errors'] : null;
        if (errors is Map) {
          return (errors.values.first as List).first as String;
        }
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return 'Koneksi terputus. Periksa jaringan Anda.';
      }
      if (e.type == DioExceptionType.connectionError) {
        return 'Tidak dapat terhubung ke server. Pastikan server menyala.';
      }
      return 'Terjadi kesalahan. Silakan coba lagi.';
    }
    return e.toString();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
