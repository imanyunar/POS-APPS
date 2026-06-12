import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

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
          'Order Detail',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('#1024', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Active', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          const Text('12 Jun 2026, 14:30', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Dine In', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.warning)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 16, color: AppColors.accent),
                      label: const Text('Add Item', style: TextStyle(color: AppColors.accent)),
                    ),
                  ],
                ),
                ..._items.map((item) => _ItemRow(item: item)),
                const Divider(height: 24),
                _TotalRow(label: 'Subtotal', value: 'Rp 85.000'),
                const SizedBox(height: 6),
                _TotalRow(label: 'Discount (10%)', value: '-Rp 8.500'),
                const SizedBox(height: 6),
                _TotalRow(label: 'Tax (PPN 11%)', value: 'Rp 9.350'),
                const SizedBox(height: 6),
                _TotalRow(label: 'Total', value: 'Rp 85.850', isBold: true),
                const SizedBox(height: 6),
                _TotalRow(label: 'Amount Paid', value: 'Rp 100.000'),
                const SizedBox(height: 6),
                _TotalRow(label: 'Change', value: 'Rp 14.150'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 8, offset: Offset(0, -2))],
            ),
            child: SafeArea(
              child: PrimaryButton(
                label: 'Pay Bills - Rp 85.850',
                onPressed: () {},
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final Map<String, dynamic> item;
  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceTertiary,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(item['emoji'], style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text('x${item['qty']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(item['price'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _TotalRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: isBold ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: 14, color: isBold ? AppColors.textPrimary : AppColors.textPrimary, fontWeight: isBold ? FontWeight.bold : FontWeight.w600)),
      ],
    );
  }
}

final List<Map<String, dynamic>> _items = [
  {'name': 'Nasi Goreng Special', 'qty': 2, 'price': 'Rp 70.000', 'emoji': '\uD83C\uDF5A'},
  {'name': 'Es Teh Manis', 'qty': 1, 'price': 'Rp 5.000', 'emoji': '\uD83C\uDF75'},
  {'name': 'Pisang Goreng', 'qty': 1, 'price': 'Rp 10.000', 'emoji': '\uD83C\uDF4C'},
];
