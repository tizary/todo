import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_example/providers/cart_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Корзина')),
      body: cartAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Ошибка: $err')),
        data: (carts) {
          return ListView.builder(
            itemCount: carts.length,
            itemBuilder: (context, index) {
              final c = carts[index];
              return ListTile(
                title: Text('Cart ID: ${c.id}'),
                subtitle: Text(
                    'User ID: ${c.userId}, items: ${c.products.length}'),
              );
            },
          );
        },
      ),
    );
  }
}
