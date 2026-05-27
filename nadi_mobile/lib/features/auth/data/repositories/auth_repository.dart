import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:serve_app/core/network/dio_client.dart';
import 'package:serve_app/core/network/api_endpoints.dart';
import 'package:serve_app/features/auth/domain/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioClientProvider));
});

class AuthRepository {
  final DioClient _client;
  final _storage = const FlutterSecureStorage();

  AuthRepository(this._client);

  Future<String?> getToken() => _storage.read(key: 'auth_token');
  Future<String?> getWorkspaceId() => _storage.read(key: 'workspace_id');
  Future<void> _saveToken(String token) => _storage.write(key: 'auth_token', value: token);
  Future<void> _saveWorkspaceId(String id) => _storage.write(key: 'workspace_id', value: id);
  Future<void> _clearStorage() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'workspace_id');
  }

  void _setWorkspaceHeader(String? id) {
    if (id != null) {
      _client.dio.options.headers['X-Workspace-Id'] = id;
    } else {
      _client.dio.options.headers.remove('X-Workspace-Id');
    }
  }

  Future<AuthLoginResult> login(String email, String password) async {
    final response = await _client.dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final token = data['token'] as String;
    final user = UserModel.fromJson({
      ...data['user'] as Map<String, dynamic>,
      'workspaces': data['workspaces'] ?? [],
      'roles': data['roles'] ?? [],
      'permissions': data['permissions'] ?? [],
    });

    await _saveToken(token);
    if (user.currentWorkspaceId != null) {
      await _saveWorkspaceId(user.currentWorkspaceId!);
      _setWorkspaceHeader(user.currentWorkspaceId);
    }

    return AuthLoginResult(user: user, token: token);
  }

  Future<AuthLoginResult> register(String name, String email, String password,
      {String? businessType}) async {
    final response = await _client.dio.post(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'business_type': businessType ?? 'cafe',
      },
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final token = data['token'] as String;
    final user = UserModel.fromJson({
      ...data['user'] as Map<String, dynamic>,
      'workspaces': data['workspaces'] ?? [],
      'roles': data['roles'] ?? [],
      'permissions': data['permissions'] ?? [],
    });

    await _saveToken(token);
    if (user.currentWorkspaceId != null) {
      await _saveWorkspaceId(user.currentWorkspaceId!);
      _setWorkspaceHeader(user.currentWorkspaceId);
    }

    return AuthLoginResult(user: user, token: token);
  }

  Future<void> logout() async {
    try {
      await _client.dio.post(ApiEndpoints.logout);
    } catch (_) {}
    _setWorkspaceHeader(null);
    await _clearStorage();
  }

  Future<UserModel> fetchMe() async {
    final savedWorkspace = await getWorkspaceId();
    _setWorkspaceHeader(savedWorkspace);

    final response = await _client.dio.get(ApiEndpoints.me);
    final data = response.data['data'] as Map<String, dynamic>;

    return UserModel.fromJson({
      ...data['user'] as Map<String, dynamic>,
      'workspaces': data['workspaces'] ?? [],
      'roles': data['roles'] ?? [],
      'permissions': data['permissions'] ?? [],
    });
  }

  Future<UserModel> switchWorkspace(String workspaceId) async {
    final response = await _client.dio.post(
      ApiEndpoints.switchWorkspace,
      data: {'workspace_id': workspaceId},
    );

    final data = response.data['data'] as Map<String, dynamic>;

    await _saveWorkspaceId(workspaceId);
    _setWorkspaceHeader(workspaceId);

    return UserModel.fromJson({
      'id': '', // workspace switch returns partial user data
      'name': '',
      'email': '',
      'currentWorkspaceId': workspaceId,
      'workspaces': [],
      'roles': data['roles'] ?? [],
      'permissions': data['permissions'] ?? [],
    });
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }
}

class AuthLoginResult {
  final UserModel user;
  final String token;

  const AuthLoginResult({required this.user, required this.token});
}
