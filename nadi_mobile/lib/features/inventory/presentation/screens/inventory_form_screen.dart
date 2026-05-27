import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/features/inventory/presentation/inventory_list_provider.dart';

class InventoryFormScreen extends ConsumerStatefulWidget {
  final String? inventoryId;
  const InventoryFormScreen({super.key, this.inventoryId});

  @override
  ConsumerState<InventoryFormScreen> createState() => _InventoryFormScreenState();
}

class _InventoryFormScreenState extends ConsumerState<InventoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _qtyController = TextEditingController(text: '0');
  final _minQtyController = TextEditingController(text: '5');
  final _unitPriceController = TextEditingController();
  final _unitController = TextEditingController(text: 'pcs');
  
  bool _isLoading = false;
  bool _isInit = false;

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _qtyController.dispose();
    _minQtyController.dispose();
    _unitPriceController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _initData() {
    if (_isInit || widget.inventoryId == null) return;
    
    final inventoryAsync = ref.read(inventoryListNotifierProvider);
    inventoryAsync.whenData((items) {
      final item = items.firstWhere((i) => i.id == widget.inventoryId, orElse: () => throw Exception('Item not found'));
      _nameController.text = item.name;
      _skuController.text = item.sku;
      _qtyController.text = item.quantity.toString();
      _minQtyController.text = item.lowStockThreshold.toString();
      _unitPriceController.text = item.unitPrice.toInt().toString();
      _unitController.text = item.unit;
      
      setState(() => _isInit = true);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'name': _nameController.text,
        'sku': _skuController.text,
        'quantity': int.tryParse(_qtyController.text) ?? 0,
        'minimumQuantity': int.tryParse(_minQtyController.text) ?? 5,
        'unitPrice': double.tryParse(_unitPriceController.text) ?? 0.0,
        'unit': _unitController.text,
      };

      if (widget.inventoryId == null) {
        await ref.read(inventoryListNotifierProvider.notifier).createInventoryItem(data);
      } else {
        await ref.read(inventoryListNotifierProvider.notifier).updateInventoryItem(widget.inventoryId!, data);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.inventoryId == null ? 'Barang ditambahkan' : 'Barang diperbarui'),
            backgroundColor: ServeColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: ServeColors.danger),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initData();

    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: Text(widget.inventoryId != null ? 'Edit Barang' : 'Tambah Stok Barang'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text('Simpan'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Informasi Barang', style: ServeTypography.h3(color: ServeColors.textPrimary)),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Barang',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _skuController,
                decoration: InputDecoration(
                  labelText: 'SKU / Kode Barang',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _unitPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Harga Beli Satuan',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: InputDecoration(
                        labelText: 'Satuan (Misal: kg, pcs)',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              Text('Manajemen Kuantitas', style: ServeTypography.h3(color: ServeColors.textPrimary)),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Stok Saat Ini',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _minQtyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Batas Minimum Stok',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
