import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/customers/presentation/screens/customer_list_screen.dart';
import '../../features/customers/presentation/screens/customer_form_screen.dart';
import '../../features/customers/presentation/screens/customer_detail_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/orders/presentation/screens/order_create_screen.dart';
import '../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../features/orders/presentation/screens/order_edit_screen.dart';
import '../../features/invoices/presentation/screens/invoices_screen.dart';
import '../../features/invoices/presentation/screens/invoice_builder_screen.dart';
import '../../features/invoices/presentation/screens/invoice_detail_screen.dart';
import '../../features/tasks/presentation/screens/tasks_screen.dart';
import '../../features/tasks/presentation/screens/task_form_screen.dart';
import '../../features/notes/presentation/screens/notes_screen.dart';
import '../../features/notes/presentation/screens/note_form_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/inventory/presentation/screens/inventory_form_screen.dart';
import '../../features/menu/presentation/screens/menu_screen.dart';
import '../../features/menu/presentation/screens/menu_item_form_screen.dart';
import '../../features/more/presentation/screens/more_menu_screen.dart';
import '../../features/timeline/presentation/screens/timeline_screen.dart';
import '../shell/app_shell.dart';

final _authGuard = ValueNotifier<AuthState>(const AuthState());

final appRouterProvider = Provider<GoRouter>((ref) {
  ref.listen<AuthState>(authProvider, (_, next) {
    _authGuard.value = next;
  });

  return GoRouter(
    initialLocation: '/auth/login',
    debugLogDiagnostics: true,
    refreshListenable: _authGuard,
    redirect: (context, state) {
      final authState = _authGuard.value;
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isAuthenticated && !isAuthRoute) {
        return '/auth/login';
      }

      if (isAuthenticated && isAuthRoute) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/customers',
            name: 'customers',
            builder: (context, state) => const CustomerListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                name: 'customer-create',
                builder: (context, state) => const CustomerFormScreen(),
              ),
              GoRoute(
                path: ':id',
                name: 'customer-detail',
                builder: (context, state) =>
                    CustomerDetailScreen(customerId: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'customer-edit',
                    builder: (context, state) =>
                        CustomerFormScreen(customerId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/orders',
            name: 'orders',
            builder: (context, state) => const OrdersScreen(),
            routes: [
              GoRoute(
                path: 'create',
                name: 'order-create',
                builder: (context, state) => const OrderCreateScreen(),
              ),
              GoRoute(
                path: ':id',
                name: 'order-detail',
                builder: (context, state) =>
                    OrderDetailScreen(orderId: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'order-edit',
                    builder: (context, state) =>
                        OrderEditScreen(orderId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/invoices',
            name: 'invoices',
            builder: (context, state) => const InvoicesScreen(),
            routes: [
              GoRoute(
                path: 'create',
                name: 'invoice-create',
                builder: (context, state) => const InvoiceBuilderScreen(),
              ),
              GoRoute(
                path: ':id',
                name: 'invoice-detail',
                builder: (context, state) =>
                    InvoiceDetailScreen(invoiceId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/more',
            name: 'more',
            builder: (context, state) => const MoreMenuScreen(),
            routes: [
              GoRoute(
                path: 'tasks',
                name: 'tasks',
                builder: (context, state) => const TasksScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    name: 'task-create',
                    builder: (context, state) => const TaskFormScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: 'notes',
                name: 'notes',
                builder: (context, state) => const NotesScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    name: 'note-create',
                    builder: (context, state) => const NoteFormScreen(),
                  ),
                  GoRoute(
                    path: ':id/edit',
                    name: 'note-edit',
                    builder: (context, state) =>
                        NoteFormScreen(noteId: state.pathParameters['id']),
                  ),
                ],
              ),
              GoRoute(
                path: 'inventory',
                name: 'inventory',
                builder: (context, state) => const InventoryScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    name: 'inventory-create',
                    builder: (context, state) => const InventoryFormScreen(),
                  ),
                  GoRoute(
                    path: ':id/edit',
                    name: 'inventory-edit',
                    builder: (context, state) =>
                        InventoryFormScreen(inventoryId: state.pathParameters['id']),
                  ),
                ],
              ),
              GoRoute(
                path: 'menu',
                name: 'menu',
                builder: (context, state) => const MenuScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    name: 'menu-create',
                    builder: (context, state) => const MenuItemFormScreen(),
                  ),
                  GoRoute(
                    path: ':id/edit',
                    name: 'menu-edit',
                    builder: (context, state) =>
                        MenuItemFormScreen(menuItemId: state.pathParameters['id']),
                  ),
                ],
              ),
              GoRoute(
                path: 'timeline',
                name: 'timeline',
                builder: (context, state) => const TimelineScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
