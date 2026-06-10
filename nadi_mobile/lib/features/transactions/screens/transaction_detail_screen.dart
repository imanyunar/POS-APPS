import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_provider.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final int transactionId;
  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync =
        ref.watch(transactionDetailProvider(transactionId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: detailAsync.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Row('ID Transaksi', '#${data['id']}'),
                    _Row('Tanggal',
                        '${data['created_at']}'),
                    _Row('Kasir',
                        '${data['cashier']?['name'] ?? '-'}'),
                    _Row('Metode Bayar',
                        '${data['payment_method']}'),
                    _Row('Status',
                        '${data['status']}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Item',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: ((data['items'] ?? []) as List).map((item) {
                  final subtotal = (item['subtotal'] as int?) ?? 0;
                  return ListTile(
                    title: Text(item['product_name'] ?? ''),
                    subtitle: Text(
                        '${item['qty']} x Rp ${(item['price'] as int).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}'),
                    trailing: Text(
                        'Rp ${subtotal.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}'),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.indigo[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Row('Total',
                        'Rp ${(data['total'] as int).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}'),
                    if ((data['discount'] as int?) != null &&
                        data['discount'] > 0)
                      _Row('Diskon',
                          '-Rp ${(data['discount'] as int).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}'),
                    const Divider(),
                    _Row('Grand Total',
                        'Rp ${(data['grand_total'] as int).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                        bold: true),
                    _Row('Bayar',
                        'Rp ${(data['amount_paid'] as int).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}'),
                    _Row('Kembalian',
                        'Rp ${(data['change'] as int).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                        color: Colors.green),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? color;

  const _Row(this.label, this.value, {this.bold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color ?? Colors.grey[600])),
          Text(value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: color,
              )),
        ],
      ),
    );
  }
}
