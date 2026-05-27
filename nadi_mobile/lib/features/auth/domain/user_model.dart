class WorkspaceInfo {
  final String id;
  final String name;
  final String slug;
  final String role;

  const WorkspaceInfo({
    required this.id,
    required this.name,
    required this.slug,
    required this.role,
  });

  factory WorkspaceInfo.fromJson(Map<String, dynamic> json) {
    return WorkspaceInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      role: json['role'] as String,
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? currentWorkspaceId;
  final List<WorkspaceInfo> workspaces;
  final List<String> roles;
  final List<String> permissions;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.currentWorkspaceId,
    this.workspaces = const [],
    this.roles = const [],
    this.permissions = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      email: json['email'] as String,
      currentWorkspaceId: json['currentWorkspaceId'] as String?,
      workspaces: (json['workspaces'] as List<dynamic>?)
              ?.map((e) => WorkspaceInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      roles: (json['roles'] as List<dynamic>?)?.cast<String>() ?? [],
      permissions:
          (json['permissions'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  bool get hasWorkspaces => workspaces.isNotEmpty;
  bool hasPermission(String permission) => permissions.contains(permission);
  bool hasRole(String role) => roles.map((r) => r.toLowerCase()).contains(role.toLowerCase());
  bool get isOwner => hasRole('Owner');
  bool get isManager => hasRole('Manager');
  bool get isCashier => hasRole('Cashier');
  bool get isKitchenStaff => hasRole('Kitchen Staff');
  bool get isStaff => hasRole('Staff');
  bool get isViewer => hasRole('Viewer');

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? currentWorkspaceId,
    List<WorkspaceInfo>? workspaces,
    List<String>? roles,
    List<String>? permissions,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      currentWorkspaceId: currentWorkspaceId ?? this.currentWorkspaceId,
      workspaces: workspaces ?? this.workspaces,
      roles: roles ?? this.roles,
      permissions: permissions ?? this.permissions,
    );
  }
}
