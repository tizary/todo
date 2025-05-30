import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'product_model.dart';
import 'cart_model.dart';

part 'store_api.g.dart';

@RestApi(baseUrl: "https://fakestoreapi.com")
abstract class StoreApi {
  factory StoreApi(Dio dio, {String baseUrl}) = _StoreApi;

  @GET("/products")
  Future<List<Product>> getProducts();

  @GET("/carts")
  Future<List<Cart>> getCarts();
}
