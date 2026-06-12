import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/menu/screens/menu_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/customer/screens/customer_info_screen.dart';
import '../features/order_detail/screens/order_detail_screen.dart';
import '../features/pos/screens/pos_screen.dart';
import '../features/pos/screens/payment_screen.dart';
import '../features/pos/screens/receipt_screen.dart';
import '../features/products/screens/product_list_screen.dart';
import '../features/products/screens/product_form_screen.dart';
import '../features/transactions/screens/transaction_list_screen.dart';
import '../features/transactions/screens/transaction_detail_screen.dart';
import 'api_client.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final token = ref.read(authTokenProvider);
      final isLoggedIn = token != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/menu',
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: '/customer_info',
        builder: (context, state) => const CustomerInfoScreen(),
      ),
      GoRoute(
        path: '/order_detail',
        builder: (context, state) => const OrderDetailScreen(),
      ),
      GoRoute(
        path: '/pos',
        builder: (context, state) => const PosScreen(),
      ),
      GoRoute(
        path: '/payment',
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/receipt/:id',
        builder: (context, state) => ReceiptScreen(
          transactionId: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductListScreen(),
      ),
      GoRoute(
        path: '/products/create',
        builder: (context, state) => const ProductFormScreen(),
      ),
      GoRoute(
        path: '/products/:id/edit',
        builder: (context, state) => ProductFormScreen(
          productId: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionListScreen(),
      ),
      GoRoute(
        path: '/transactions/:id',
        builder: (context, state) => TransactionDetailScreen(
          transactionId: int.parse(state.pathParameters['id']!),
        ),
      ),
    ],
  );

  ref.listen(authTokenProvider, (previous, next) {
    router.refresh();
  });

  return router;
}
