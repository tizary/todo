import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_example/providers/product_provider.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Товары')),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Ошибка: $err')),
        data: (products) {
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ListTile(
                leading: Image.network(p.image, width: 50, height: 50),
                title: Text(p.title),
                subtitle: Text('${p.price} \$'),
              );
            },
          );
        },
      ),
    );
  }
}
