import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api_client.dart';

part 'pos_provider.g.dart';

class CartItem {
  final int productId;
  final String name;
  final int price;
  final int qty;

  const CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.qty = 1,
  });

  int get subtotal => price * qty;

  // BUG-05 fix: buat method copyWith agar CartItem bisa diganti tanpa mutasi
  CartItem copyWith({int? qty}) => CartItem(
        productId: productId,
        name: name,
        price: price,
        qty: qty ?? this.qty,
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'qty': qty,
        'discount': 0,
      };
}

// BUG-03 fix: nama class harus CartNotifier agar ter-generate sebagai cartNotifierProvider
@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  List<CartItem> build() => [];

  void addItem(CartItem item) {
    final existing = state.indexWhere((e) => e.productId == item.productId);
    if (existing >= 0) {
      // BUG-05 fix: JANGAN mutasi objek langsung; buat salinan baru
      final updated = state[existing].copyWith(qty: state[existing].qty + 1);
      state = [
        ...state.sublist(0, existing),
        updated,
        ...state.sublist(existing + 1),
      ];
    } else {
      state = [...state, item];
    }
  }

  void removeItem(int index) {
    state = [...state]..removeAt(index);
  }

  void updateQty(int index, int qty) {
    if (qty <= 0) {
      removeItem(index);
      return;
    }
    // BUG-05 fix: buat objek baru via copyWith
    final updated = state[index].copyWith(qty: qty);
    state = [
      ...state.sublist(0, index),
      updated,
      ...state.sublist(index + 1),
    ];
  }

  void clear() {
    state = [];
  }

  int get total => state.fold(0, (sum, item) => sum + item.subtotal);
  int get itemCount => state.fold(0, (sum, item) => sum + item.qty);
}

@riverpod
Future<List<Map<String, dynamic>>> posProducts(Ref ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('/products', queryParameters: {
    'per_page': 100,
  });
  final data = response.data;
  return (data['data'] as List).cast<Map<String, dynamic>>();
}

Future<Map<String, dynamic>> createTransaction(
    WidgetRef ref, Map<String, dynamic> data) async {
  final dio = ref.read(dioProvider);
  final response = await dio.post('/transactions', data: data);
  return response.data as Map<String, dynamic>;
}
