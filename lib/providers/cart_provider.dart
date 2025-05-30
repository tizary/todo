import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:todos_example/data/api/store_api.dart';
import 'package:todos_example/domain/models/cart_model.dart';


final dioProvider = Provider((ref) => Dio());
final storeApiProvider = Provider((ref) => StoreApi(ref.watch(dioProvider)));

final cartListProvider = FutureProvider<List<Cart>>((ref) async {
  final api = ref.watch(storeApiProvider);
  final carts = await api.getCarts();
  return carts;
});
