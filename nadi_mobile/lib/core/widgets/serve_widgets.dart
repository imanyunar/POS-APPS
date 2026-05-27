import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';

class ServeCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const ServeCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(12);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null
            ? () {
                HapticFeedback.lightImpact();
                onTap!();
              }
            : null,
        borderRadius: br,
        splashColor: ServeColors.primary.withValues(alpha: 0.06),
        highlightColor: ServeColors.primary.withValues(alpha: 0.03),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color ?? ServeColors.bgCard,
            borderRadius: br,
            border: Border.all(color: ServeColors.border, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class ServeBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;
  final IconData? icon;

  const ServeBadge({
    super.key,
    required this.label,
    required this.color,
    required this.backgroundColor,
    this.icon,
  });

  ServeBadge copyWith({
    String? label,
    Color? color,
    Color? backgroundColor,
    IconData? icon,
  }) {
    return ServeBadge(
      label: label ?? this.label,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      icon: icon ?? this.icon,
    );
  }

  factory ServeBadge.paid() => const ServeBadge(
        label: 'Lunas',
        color: ServeColors.success,
        backgroundColor: ServeColors.successBg,
        icon: Icons.check_circle_rounded,
      );

  factory ServeBadge.unpaid() => const ServeBadge(
        label: 'Belum Bayar',
        color: ServeColors.warning,
        backgroundColor: ServeColors.warningBg,
        icon: Icons.schedule_rounded,
      );

  factory ServeBadge.overdue() => const ServeBadge(
        label: 'Jatuh Tempo',
        color: ServeColors.danger,
        backgroundColor: ServeColors.dangerBg,
        icon: Icons.warning_rounded,
      );

  factory ServeBadge.pending() => const ServeBadge(
        label: 'Pending',
        color: ServeColors.orderPending,
        backgroundColor: ServeColors.warningBg,
      );

  factory ServeBadge.preparing() => const ServeBadge(
        label: 'Dimasak',
        color: ServeColors.orderPreparing,
        backgroundColor: ServeColors.infoBg,
      );

  factory ServeBadge.ready() => const ServeBadge(
        label: 'Siap',
        color: ServeColors.orderReady,
        backgroundColor: Color(0xFFF3E8FF),
      );

  factory ServeBadge.completed() => const ServeBadge(
        label: 'Selesai',
        color: ServeColors.success,
        backgroundColor: ServeColors.successBg,
      );

  factory ServeBadge.cancelled() => const ServeBadge(
        label: 'Dibatalkan',
        color: ServeColors.danger,
        backgroundColor: ServeColors.dangerBg,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: ServeTypography.labelSmall(color: color),
          ),
        ],
      ),
    );
  }
}

class ServeSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ServeSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: ServeTypography.h3(color: ServeColors.textPrimary)),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: ServeTypography.labelSmall(color: ServeColors.primary),
            ),
          ),
      ],
    );
  }
}

class ServeShimmerCard extends StatelessWidget {
  final double height;

  const ServeShimmerCard({super.key, this.height = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: ServeColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ServeColors.border),
      ),
    );
  }
}

class ServeEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ServeEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: ServeColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 32, color: ServeColors.primary),
            ),
            const SizedBox(height: 16),
            Text(title,
                style: ServeTypography.h3(color: ServeColors.textPrimary),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle,
                style: ServeTypography.bodyMedium(color: ServeColors.textSecondary),
                textAlign: TextAlign.center),
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
