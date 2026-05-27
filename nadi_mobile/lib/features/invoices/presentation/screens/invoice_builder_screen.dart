import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/core/utils/formatters.dart';
import 'package:serve_app/features/invoices/presentation/invoice_list_provider.dart';

class InvoiceBuilderScreen extends ConsumerStatefulWidget {
  const InvoiceBuilderScreen({super.key});

  @override
  ConsumerState<InvoiceBuilderScreen> createState() => _InvoiceBuilderScreenState();
}

class _InvoiceBuilderScreenState extends ConsumerState<InvoiceBuilderScreen> {
  final List<Map<String, dynamic>> _items = [];
  final _taxController = TextEditingController(text: '0');
  
  bool _isSubmitting = false;

  @override
  void dispose() {
    _taxController.dispose();
    super.dispose();
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (context) {
        final nameCtrl = TextEditingController();
        final qtyCtrl = TextEditingController(text: '1');
        final priceCtrl = TextEditingController();
        return AlertDialog(
          title: const Text('Tambah Item Tagihan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Deskripsi Item', isDense: true),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Qty', isDense: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Harga Satuan', isDense: true),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            FilledButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
                  setState(() {
                    _items.add({
                      'name': nameCtrl.text,
                      'quantity': int.tryParse(qtyCtrl.text) ?? 1,
                      'unitPrice': double.tryParse(priceCtrl.text) ?? 0.0,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      }
    );
  }

  Future<void> _submitInvoice() async {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambahkan minimal 1 item'), backgroundColor: ServeColors.warning),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final tax = double.tryParse(_taxController.text) ?? 0.0;
      final payload = {
        'tax': tax,
        'items': _items,
      };

      await ref.read(invoiceListNotifierProvider.notifier).createInvoice(payload);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tagihan dibuat'), backgroundColor: ServeColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat tagihan: $e'), backgroundColor: ServeColors.danger),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = _items.fold(0, (sum, item) => sum + (item['quantity'] * item['unitPrice']));
    double tax = double.tryParse(_taxController.text) ?? 0.0;
    double total = subtotal + tax;

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: const Text('Buat Tagihan Baru'),
        actions: [
          if (_isSubmitting)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else
            TextButton(
              onPressed: _submitInvoice,
              child: const Text('Simpan'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Rincian Item', style: ServeTypography.h3(color: ServeColors.textPrimary)),
          const SizedBox(height: 12),
          
          if (_items.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ServeColors.border),
              ),
              child: const Center(child: Text('Belum ada item ditambahkan', style: TextStyle(color: ServeColors.textMuted))),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ServeColors.border),
              ),
              child: Column(
                children: _items.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('${item['quantity']} x ${ServeFormatters.rupiah(item['unitPrice'])}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(ServeFormatters.rupiah(item['quantity'] * item['unitPrice']), 
                          style: ServeTypography.labelMedium(color: ServeColors.textPrimary)),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: ServeColors.danger, size: 20),
                          onPressed: () => setState(() => _items.removeAt(idx)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
            label: const Text('Tambah Item'),
          ),

          const SizedBox(height: 32),
          Text('Ringkasan Biaya', style: ServeTypography.h3(color: ServeColors.textPrimary)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ServeColors.border),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: ServeTypography.bodyMedium(color: ServeColors.textSecondary)),
                    Text(ServeFormatters.rupiah(subtotal), style: ServeTypography.labelMedium(color: ServeColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pajak / Biaya Lain', style: ServeTypography.bodyMedium(color: ServeColors.textSecondary)),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _taxController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(isDense: true, prefixText: 'Rp '),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Tagihan', style: ServeTypography.h3(color: ServeColors.textPrimary)),
                    Text(ServeFormatters.rupiah(total), style: ServeTypography.h2(color: ServeColors.primary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
