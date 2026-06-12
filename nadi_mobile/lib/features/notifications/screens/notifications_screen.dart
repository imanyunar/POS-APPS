import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _NotificationGroup(
            title: 'Today',
            notifications: _todayNotifs,
          ),
          const SizedBox(height: 20),
          _NotificationGroup(
            title: 'Yesterday',
            notifications: _yesterdayNotifs,
          ),
          const SizedBox(height: 20),
          _NotificationGroup(
            title: 'This Week',
            notifications: _weekNotifs,
          ),
        ],
      ),
    );
  }
}

class _NotificationGroup extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> notifications;

  const _NotificationGroup({required this.title, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ...notifications.map((n) => _NotificationCard(notif: n)),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notif;
  const _NotificationCard({required this.notif});

  Color _borderColor(String type) {
    switch (type) {
      case 'order':
        return AppColors.accent;
      case 'payment':
        return AppColors.success;
      case 'promo':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: _borderColor(notif['type']), width: 3)),
      ),
      child: Row(
        children: [
          Icon(_iconFor(notif['type']), size: 20, color: _borderColor(notif['type'])),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif['title'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(notif['body'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(notif['time'], style: const TextStyle(fontSize: 11, color: AppColors.textDisabled)),
        ],
      ),
    );
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'payment':
        return Icons.credit_card;
      case 'promo':
        return Icons.local_offer;
      default:
        return Icons.notifications;
    }
  }
}

final List<Map<String, dynamic>> _todayNotifs = [
  {'type': 'order', 'title': 'New order #1024', 'body': 'Nasi Goreng Special x2, Es Teh x1', 'time': '5m'},
  {'type': 'payment', 'title': 'Payment confirmed', 'body': 'Rp 75.000 from order #1023', 'time': '12m'},
  {'type': 'promo', 'title': 'Happy Hour starts now!', 'body': '20% off all beverages until 5 PM', 'time': '30m'},
];

final List<Map<String, dynamic>> _yesterdayNotifs = [
  {'type': 'order', 'title': 'New order #1020', 'body': 'Ayam Bakar x1, Mie Goreng x1', 'time': '2h'},
  {'type': 'order', 'title': 'Order #1018 completed', 'body': 'Total Rp 125.000', 'time': '4h'},
  {'type': 'payment', 'title': 'Daily report ready', 'body': 'Yesterday revenue: Rp 2.100.000', 'time': '8h'},
];

final List<Map<String, dynamic>> _weekNotifs = [
  {'type': 'promo', 'title': 'New menu item added', 'body': 'Try our new Sate Ayam!', 'time': '2d'},
  {'type': 'order', 'title': 'Weekly summary', 'body': 'Total orders: 187 this week', 'time': '3d'},
];
