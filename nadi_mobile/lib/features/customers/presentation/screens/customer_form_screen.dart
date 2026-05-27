import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serve_app/core/constants/colors.dart';
import 'package:serve_app/core/constants/typography.dart';
import 'package:serve_app/features/customers/presentation/customer_list_provider.dart';
import 'package:serve_app/features/customers/presentation/customer_detail_provider.dart';

class CustomerFormScreen extends ConsumerStatefulWidget {
  final String? customerId;
  const CustomerFormScreen({super.key, this.customerId});

  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isLoading = false;
  bool _isInit = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'name': _nameController.text,
        'phone': _phoneController.text,
      };

      if (widget.customerId == null) {
        await ref.read(customerListNotifierProvider.notifier).createCustomer(data);
      } else {
        await ref.read(customerListNotifierProvider.notifier).updateCustomer(widget.customerId!, data);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.customerId == null ? 'Pelanggan ditambahkan' : 'Pelanggan diperbarui'),
            backgroundColor: ServeColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: ServeColors.danger,
          ),
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
    // If editing, fetch data to prepopulate
    if (widget.customerId != null) {
      final customerAsync = ref.watch(customerDetailProvider(widget.customerId!));
      
      return customerAsync.when(
        data: (customer) {
          if (!_isInit) {
            _nameController.text = customer.name;
            _phoneController.text = customer.phone;
            _isInit = true;
          }
          return _buildForm(context);
        },
        loading: () => Scaffold(
          backgroundColor: ServeColors.bgBase,
          appBar: AppBar(title: const Text('Edit Pelanggan')),
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => Scaffold(
          backgroundColor: ServeColors.bgBase,
          appBar: AppBar(title: const Text('Edit Pelanggan')),
          body: Center(child: Text('Error: $err')),
        ),
      );
    }

    return _buildForm(context);
  }

  Widget _buildForm(BuildContext context) {
    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(
        title: Text(widget.customerId != null ? 'Edit Pelanggan' : 'Tambah Pelanggan'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
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
              Text('Informasi Dasar', style: ServeTypography.h3(color: ServeColors.textPrimary)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan nama pelanggan',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  hintText: 'Contoh: 08123456789',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Nomor telepon wajib diisi' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
