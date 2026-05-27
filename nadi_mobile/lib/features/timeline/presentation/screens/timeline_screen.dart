import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/widgets/serve_widgets.dart';
import 'package:serve_app/core/utils/formatters.dart';
import 'package:serve_app/features/timeline/domain/activity_model.dart';
import '../activity_list_provider.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  @override
  Widget build(BuildContext context) {
    final activitiesAsync = ref.watch(activityListNotifierProvider);

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Aktivitas'),
      ),
      body: activitiesAsync.when(
        data: (activities) {
          if (activities.isEmpty) {
            return const ServeEmptyState(
              icon: Icons.timeline_rounded,
              title: 'Belum ada aktivitas',
              subtitle: 'Riwayat aktivitas akan muncul di sini.',
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(activityListNotifierProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _ActivityCard(activity: activities[index]);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Gagal memuat aktivitas',
                style: ServeTypography.bodyMedium(color: ServeColors.danger)),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref.read(activityListNotifierProvider.notifier).refresh(),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final ActivityModel activity;

  const _ActivityCard({required this.activity});

  (IconData, Color, Color) get _iconData => switch (activity.type) {
    'order_created' => (Icons.receipt_long_rounded, ServeColors.accentTeal, ServeColors.accentTealBg),
    'invoice_created' => (Icons.description_rounded, ServeColors.accentIndigo, ServeColors.accentIndigoBg),
    'invoice_paid' => (Icons.paid_rounded, ServeColors.success, ServeColors.successBg),
    'customer_created' => (Icons.person_add_rounded, ServeColors.info, ServeColors.infoBg),
    _ => (Icons.event_note_rounded, ServeColors.textSecondary, ServeColors.bgCard),
  };

  String get _description {
    final details = activity.details;
    return switch (activity.type) {
      'order_created' => 'Pesanan ${details?['order_number'] ?? ''} dibuat'
          '${details?['total'] != null ? ' — ${ServeFormatters.rupiahCompact((details!['total'] as num).toDouble())}' : ''}',
      'invoice_created' => 'Invoice ${details?['invoice_number'] ?? ''} dibuat'
          '${details?['total'] != null ? ' — ${ServeFormatters.rupiahCompact((details!['total'] as num).toDouble())}' : ''}',
      'invoice_paid' => 'Invoice ${details?['invoice_number'] ?? ''} dibayar',
      'customer_created' => 'Pelanggan baru ditambahkan',
      _ => activity.type.replaceAll('_', ' '),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color, bgColor) = _iconData;
    final date = activity.createdAt != null ? DateTime.tryParse(activity.createdAt!) : null;

    return ServeCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (activity.customerName != null)
                  Text(activity.customerName!, style: ServeTypography.labelMedium(color: ServeColors.textPrimary)),
                const SizedBox(height: 2),
                Text(_description, style: ServeTypography.bodySmall(color: ServeColors.textSecondary)),
                if (date != null) ...[
                  const SizedBox(height: 4),
                  Text(ServeFormatters.dateShort(date),
                    style: ServeTypography.labelSmall(color: ServeColors.textMuted)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
