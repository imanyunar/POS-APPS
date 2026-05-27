import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/features/menu/presentation/menu_list_provider.dart';

class MenuItemFormScreen extends ConsumerStatefulWidget {
  final String? menuItemId;
  const MenuItemFormScreen({super.key, this.menuItemId});

  @override
  ConsumerState<MenuItemFormScreen> createState() => _MenuItemFormScreenState();
}

class _MenuItemFormScreenState extends ConsumerState<MenuItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _prepController = TextEditingController(text: '10');
  
  String _category = 'food';
  bool _isAvailable = true;
  bool _trackStock = false;
  
  bool _isLoading = false;
  bool _isInit = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _prepController.dispose();
    super.dispose();
  }

  void _initData() {
    if (_isInit || widget.menuItemId == null) return;
    
    final menuItemsAsync = ref.read(menuListNotifierProvider);
    menuItemsAsync.whenData((items) {
      final item = items.firstWhere((i) => i.id == widget.menuItemId, orElse: () => throw Exception('Item not found'));
      _nameController.text = item.name;
      _descController.text = item.description;
      _priceController.text = item.price.toInt().toString();
      _prepController.text = item.estimatedPrepMinutes.toString();
      _category = item.category;
      _isAvailable = item.isAvailable;
      _trackStock = item.trackStock;
      
      setState(() => _isInit = true);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'name': _nameController.text,
        'description': _descController.text,
        'price': double.tryParse(_priceController.text) ?? 0,
        'category': _category,
        'estimatedPrepMinutes': int.tryParse(_prepController.text) ?? 10,
        'isAvailable': _isAvailable,
        'trackStock': _trackStock,
      };

      if (widget.menuItemId == null) {
        await ref.read(menuListNotifierProvider.notifier).createMenuItem(data);
      } else {
        await ref.read(menuListNotifierProvider.notifier).updateMenuItem(widget.menuItemId!, data);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.menuItemId == null ? 'Menu ditambahkan' : 'Menu diperbarui'),
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
        title: Text(widget.menuItemId != null ? 'Edit Menu' : 'Tambah Menu'),
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
              Text('Informasi Menu', style: ServeTypography.h3(color: ServeColors.textPrimary)),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Hidangan',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _descController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
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
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Harga (Rp)',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _category,
                      items: const [
                        DropdownMenuItem(value: 'food', child: Text('Makanan')),
                        DropdownMenuItem(value: 'beverage', child: Text('Minuman')),
                        DropdownMenuItem(value: 'dessert', child: Text('Dessert')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _category = val);
                      },
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _prepController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Estimasi Masak (Menit)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),
              
              Text('Pengaturan', style: ServeTypography.h3(color: ServeColors.textPrimary)),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Tersedia (Bisa dipesan)'),
                value: _isAvailable,
                onChanged: (val) => setState(() => _isAvailable = val),
                activeColor: ServeColors.success,
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                title: const Text('Lacak Stok Inventori'),
                value: _trackStock,
                onChanged: (val) => setState(() => _trackStock = val),
                activeColor: ServeColors.primary,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
