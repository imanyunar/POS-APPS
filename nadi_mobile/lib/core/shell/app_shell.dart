import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/permissions/permission_service.dart';
import '../constants/colors.dart';

class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});



  List<({String path, String label, IconData icon})> _visibleTabs(
      PermissionService ps) {
    final tabs = <({String path, String label, IconData icon})>[];

    tabs.add((path: '/dashboard', label: 'Beranda', icon: Icons.home_rounded));

    if (ps.canManageCustomers()) {
      tabs.add((path: '/customers', label: 'Pelanggan', icon: Icons.people_outline_rounded));
    }

    if (ps.canManageOrders() || ps.canManageKitchen()) {
      tabs.add((path: '/orders', label: 'Pesanan', icon: Icons.receipt_long_rounded));
    }

    if (ps.canManagePayments()) {
      tabs.add((path: '/invoices', label: 'Invoice', icon: Icons.description_outlined));
    }

    tabs.add((path: '/more', label: 'Lainnya', icon: Icons.grid_view_rounded));

    return tabs;
  }

  int _currentIndex(BuildContext context, List tabs) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < tabs.length; i++) {
      if (location.startsWith(tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ps = ref.watch(permissionServiceProvider);
    final tabs = _visibleTabs(ps);
    final currentIndex = _currentIndex(context, tabs);

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(tabs.length, (i) {
                final isActive = i == currentIndex;
                final isCenter = tabs[i].path == '/orders';
                return GestureDetector(
                  onTap: () {
                    if (currentIndex != i) context.go(tabs[i].path);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: isActive ? 16 : 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive && !isCenter
                          ? ServeColors.primaryLight
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isCenter
                        ? _buildCenterNav(isActive)
                        : _buildNavItem(tabs[i].icon, tabs[i].label, isActive),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24,
          color: isActive ? ServeColors.primary : ServeColors.textMuted,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? ServeColors.primary : ServeColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildCenterNav(bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: ServeColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: ServeColors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: const Icon(
            Icons.receipt_long_rounded,
            size: 22,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Pesanan',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: ServeColors.primary,
          ),
        ),
      ],
    );
  }
}
