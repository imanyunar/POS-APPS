import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serve_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:serve_app/features/auth/domain/user_model.dart';

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService(ref);
});

class PermissionService {
  final Ref _ref;

  PermissionService(this._ref);

  UserModel? get _user => _ref.read(authProvider).user;

  bool can(String permission) => _user?.hasPermission(permission) ?? false;

  bool hasRole(String role) => _user?.hasRole(role) ?? false;

  bool canManageOrders() => can('manage_orders');
  bool canManageInventory() => can('manage_inventory');
  bool canManageCustomers() => can('manage_customers');
  bool canManageStaff() => can('manage_staff');
  bool canManagePayments() => can('manage_payments');
  bool canManageTasks() => can('manage_tasks');
  bool canManageNotes() => can('manage_notes');
  bool canViewReports() => can('view_reports');
  bool canManageSettings() => can('manage_settings');
  bool canManageWorkspace() => can('manage_workspace');
  bool canManageKitchen() => can('manage_kitchen');
  bool canViewDashboard() => can('view_dashboard');

  bool get isOwner => hasRole('Owner');
  bool get isManager => hasRole('Manager');
  bool get isCashier => hasRole('Cashier');
  bool get isKitchenStaff => hasRole('Kitchen Staff');
  bool get isStaff => hasRole('Staff');
  bool get isViewer => hasRole('Viewer');
}
