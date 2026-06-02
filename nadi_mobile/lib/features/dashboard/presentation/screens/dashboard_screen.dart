import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/utils/formatters.dart';
import 'package:serve_app/features/auth/presentation/providers/auth_provider.dart';
import '../dashboard_vitals_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final vitalsAsync = ref.watch(dashboardVitalsNotifierProvider);
    final authState = ref.watch(authProvider);
    final userName = authState.user?.name ?? 'User';

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardVitalsNotifierProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(userName)),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Vitals Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: vitalsAsync.when(
                  data: (vitals) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ringkasan Hari Ini', style: ServeTypography.h3(color: ServeColors.textPrimary)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _VitalCard(
                              icon: Icons.attach_money_rounded,
                              iconBgColor: ServeColors.successBg,
                              iconColor: ServeColors.success,
                              label: 'Pendapatan',
                              value: ServeFormatters.rupiahCompact(vitals.todayRevenue),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _VitalCard(
                              icon: Icons.receipt_long_rounded,
                              iconBgColor: ServeColors.warningBg,
                              iconColor: ServeColors.warning,
                              label: 'Pesanan Aktif',
                              value: '${vitals.activeOrdersCount}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _VitalCard(
                              icon: Icons.pending_actions_rounded,
                              iconBgColor: ServeColors.dangerBg,
                              iconColor: ServeColors.danger,
                              label: 'Invoice Belum Bayar',
                              value: '${vitals.pendingInvoicesCount}',
                              subtitle: ServeFormatters.rupiahCompact(vitals.pendingInvoicesAmount),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _VitalCard(
                              icon: Icons.inventory_2_outlined,
                              iconBgColor: ServeColors.accentIndigoBg,
                              iconColor: ServeColors.accentIndigo,
                              label: 'Stok Menipis',
                              value: '${vitals.lowStockCount}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _VitalCard(
                        icon: Icons.check_circle_outline_rounded,
                        iconBgColor: ServeColors.accentTealBg,
                        iconColor: ServeColors.accentTeal,
                        label: 'Tugas Selesai Hari Ini',
                        value: '${vitals.todayTasksCompleted}',
                        fullWidth: true,
                      ),

                      // --- Reminders Stack ---
                      if (vitals.pendingInvoicesCount > 0 || vitals.lowStockCount > 0) ...[
                        const SizedBox(height: 32),
                        Text('Pengingat', style: ServeTypography.h3(color: ServeColors.textPrimary)),
                        const SizedBox(height: 16),
                      ],
                      if (vitals.pendingInvoicesCount > 0)
                        _ReminderCard(
                          icon: Icons.receipt_long_rounded,
                          title: '${vitals.pendingInvoicesCount} invoice belum dibayar',
                          subtitle: 'Total ${ServeFormatters.rupiahCompact(vitals.pendingInvoicesAmount)}',
                          color: ServeColors.danger,
                          bgColor: ServeColors.dangerBg,
                          onTap: () => context.go('/invoices'),
                        ),
                      if (vitals.lowStockCount > 0)
                        Padding(
                          padding: EdgeInsets.only(top: vitals.pendingInvoicesCount > 0 ? 8 : 0),
                          child: _ReminderCard(
                            icon: Icons.inventory_2_rounded,
                            title: '$vitals.lowStockCount item stok menipis',
                            subtitle: 'Segera lakukan pengadaan barang',
                            color: ServeColors.warning,
                            bgColor: ServeColors.warningBg,
                            onTap: () => context.go('/inventory'),
                          ),
                        ),

                      const SizedBox(height: 32),
                      Text('Menu Cepat', style: ServeTypography.h3(color: ServeColors.textPrimary)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _QuickAction(
                            icon: Icons.receipt_long_rounded,
                            label: 'Pesanan',
                            color: ServeColors.accentTeal,
                            onTap: () => context.go('/orders'),
                          ),
                          _QuickAction(
                            icon: Icons.people_alt_rounded,
                            label: 'Pelanggan',
                            color: ServeColors.accentIndigo,
                            onTap: () => context.go('/customers'),
                          ),
                          _QuickAction(
                            icon: Icons.inventory_2_rounded,
                            label: 'Inventaris',
                            color: ServeColors.warning,
                            onTap: () => context.go('/inventory'),
                          ),
                          _QuickAction(
                            icon: Icons.sticky_note_2_rounded,
                            label: 'Catatan',
                            color: ServeColors.success,
                            onTap: () => context.go('/notes'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  loading: () => const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ServeColors.dangerBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline_rounded, color: ServeColors.danger, size: 32),
                        const SizedBox(height: 8),
                        Text('Gagal memuat data dashboard',
                          style: ServeTypography.bodyMedium(color: ServeColors.danger)),
                        const SizedBox(height: 12),
                        FilledButton.tonal(
                          onPressed: () => ref.read(dashboardVitalsNotifierProvider.notifier).refresh(),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF11B1A5),
            Color(0xFF8CE2DB),
            ServeColors.bgBase,
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.store_rounded, color: ServeColors.accentTeal),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hai, $userName 👋',
                        style: ServeTypography.h3(color: Colors.white),
                      ),
                      Text(
                        'Selamat datang kembali!',
                        style: ServeTypography.bodySmall(color: Colors.white.withValues(alpha: 0.8)),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                },
                tooltip: 'Keluar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VitalCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final String value;
  final String? subtitle;
  final bool fullWidth;

  const _VitalCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.value,
    this.subtitle,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ServeColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ServeColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: ServeTypography.labelSmall(color: ServeColors.textSecondary)),
                const SizedBox(height: 4),
                Text(value, style: ServeTypography.h2(color: ServeColors.textPrimary)),
                if (subtitle != null)
                  Text(subtitle!, style: ServeTypography.bodySmall(color: ServeColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _ReminderCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: ServeTypography.labelMedium(color: color)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: ServeTypography.bodySmall(color: ServeColors.textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(widget.icon, color: widget.color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(widget.label, style: ServeTypography.labelSmall(color: ServeColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
