import 'package:flutter/material.dart';
import 'package:todos_example/models/cart_model.dart';
import 'package:todos_example/models/store_api.dart';

class CartPage extends StatelessWidget {
  final StoreApi api;

  const CartPage({super.key, required this.api});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cart>>(
      future: api.getCarts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }

        final carts = snapshot.data!;
        return ListView.builder(
          itemCount: carts.length,
          itemBuilder: (context, index) {
            final cart = carts[index];
            return ListTile(
              title: Text('Cart ID: ${cart.id}'),
              subtitle: Text(
                  'User ID: ${cart.userId}, items: ${cart.products.length}'),
            );
          },
        );
      },
    );
  }
}
