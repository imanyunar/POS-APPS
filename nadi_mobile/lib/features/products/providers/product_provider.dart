import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api_client.dart';

part 'product_provider.g.dart';

@riverpod
class ProductList extends _$ProductList {
  String _search = '';
  int _page = 1;
  bool _hasMore = true;

  @override
  Future<List<Map<String, dynamic>>> build(String search) async {
    _search = search;
    _page = 1;
    _hasMore = true;
    return _fetch();
  }

  Future<List<Map<String, dynamic>>> _fetch() async {
    final dio = ref.read(dioProvider);
    final response = await dio.get('/products', queryParameters: {
      if (_search.isNotEmpty) 'search': _search,
      'page': _page,
      'per_page': 50,
    });

    final data = response.data;
    final list = (data['data'] as List).cast<Map<String, dynamic>>();
    _hasMore = data['next_page_url'] != null;
    return list;
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    _page++;
    final newItems = await _fetch();
    state = AsyncData([...state.value ?? [], ...newItems]);
  }
}

@riverpod
Future<Map<String, dynamic>> productDetail(
    Ref ref, int id) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('/products/$id');
  return response.data as Map<String, dynamic>;
}

Future<void> createProduct(WidgetRef ref, Map<String, dynamic> data) async {
  final dio = ref.read(dioProvider);
  await dio.post('/products', data: data);
  ref.invalidate(productListProvider(''));
}

Future<void> updateProduct(
    WidgetRef ref, int id, Map<String, dynamic> data) async {
  final dio = ref.read(dioProvider);
  await dio.put('/products/$id', data: data);
  ref.invalidate(productListProvider(''));
  ref.invalidate(productDetailProvider(id));
}
