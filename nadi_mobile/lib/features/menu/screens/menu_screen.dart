import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/category_chip.dart';
import '../../../core/widgets/item_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedCategory == 0
        ? _menuItems
        : _menuItems.where((item) => item['category'] == _selectedCategory).toList();

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
          'Choose Menu',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Confirm', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.cardBg,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceTertiary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search menu...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.6)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.cardBg,
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return CategoryChip(
                  label: _categories[index],
                  isActive: _selectedCategory == index,
                  onTap: () => setState(() => _selectedCategory = index),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredItems.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ItemCard(
                  name: item['name'],
                  description: item['description'],
                  price: item['price'],
                  imageEmoji: item['emoji'],
                  badge: item['badge'],
                  quantity: item['qty'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

final List<String> _categories = ['All', 'Makanan', 'Minuman', 'Snacks', 'Promo'];

final List<Map<String, dynamic>> _menuItems = [
  {'category': 1, 'name': 'Nasi Goreng Special', 'description': 'Nasi goreng with egg & chicken', 'price': 'Rp 35.000', 'emoji': '\uD83C\uDF5A', 'badge': 'Best Seller', 'qty': 0},
  {'category': 1, 'name': 'Mie Goreng', 'description': 'Stir-fried noodles with vegetables', 'price': 'Rp 25.000', 'emoji': '\uD83C\uDF5C', 'badge': null, 'qty': 0},
  {'category': 1, 'name': 'Ayam Bakar Madu', 'description': 'Grilled chicken with honey glaze', 'price': 'Rp 45.000', 'emoji': '\uD83C\uDF57', 'badge': null, 'qty': 0},
  {'category': 2, 'name': 'Es Teh Manis', 'description': 'Iced sweet tea', 'price': 'Rp 5.000', 'emoji': '\uD83C\uDF75', 'badge': null, 'qty': 0},
  {'category': 2, 'name': 'Jus Jeruk', 'description': 'Fresh orange juice', 'price': 'Rp 12.000', 'emoji': '\uD83C\uDF4A', 'badge': null, 'qty': 0},
  {'category': 2, 'name': 'Kopi Hitam', 'description': 'Black coffee', 'price': 'Rp 10.000', 'emoji': '\u2615', 'badge': null, 'qty': 0},
  {'category': 3, 'name': 'Pisang Goreng', 'description': 'Fried banana with chocolate', 'price': 'Rp 15.000', 'emoji': '\uD83C\uDF4C', 'badge': 'New', 'qty': 0},
  {'category': 3, 'name': 'Kentang Goreng', 'description': 'French fries with sauce', 'price': 'Rp 18.000', 'emoji': '\uD83C\uDF5F', 'badge': null, 'qty': 0},
];
