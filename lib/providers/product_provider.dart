import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:todos_example/data/api/store_api.dart';
import 'package:todos_example/domain/models/product_model.dart';

final dioProvider = Provider((ref) => Dio());
final storeApiProvider = Provider((ref) => StoreApi(ref.watch(dioProvider)));

final productListProvider = FutureProvider<List<Product>>((ref) async {
  final api = ref.watch(storeApiProvider);
  final products = await api.getProducts();
  return products;
});
