import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';

class CustomerInfoScreen extends StatelessWidget {
  const CustomerInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Customer Info',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.accentLight,
                        child: const Icon(Icons.person, color: AppColors.accent, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Budi Santoso', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 14, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                const Text('+62 812-3456-7890', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                const Text('Jl. Merdeka No. 45, Jakarta', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Order Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                ..._orderItems.map((item) => _OrderItemRow(item: item)),
                const Divider(height: 24),
                _SummaryRow(label: 'Subtotal', value: 'Rp 85.000'),
                const SizedBox(height: 4),
                _SummaryRow(label: 'Tax (10%)', value: 'Rp 8.500'),
                const SizedBox(height: 4),
                _SummaryRow(label: 'Delivery', value: 'Rp 5.000'),
                const Divider(height: 24),
                _SummaryRow(label: 'Total', value: 'Rp 98.500', isBold: true),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              boxShadow: AppThemeShadow.medium,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text('Rp 98.500', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accent)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Proceed to Payment',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final Map<String, dynamic> item;
  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(item['qty'].toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(item['name'], style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
          ),
          Text(item['price'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: isBold ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: isBold ? FontWeight.bold : FontWeight.w600)),
      ],
    );
  }
}

class AppThemeShadow {
  AppThemeShadow._();
  static const List<BoxShadow> medium = [
    BoxShadow(color: Color(0x10000000), blurRadius: 8, offset: Offset(0, -2)),
  ];
}

final List<Map<String, dynamic>> _orderItems = [
  {'name': 'Nasi Goreng Special', 'qty': 2, 'price': 'Rp 70.000'},
  {'name': 'Es Teh Manis', 'qty': 1, 'price': 'Rp 5.000'},
  {'name': 'Pisang Goreng', 'qty': 1, 'price': 'Rp 10.000'},
];
