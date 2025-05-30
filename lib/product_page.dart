import 'package:flutter/material.dart';
import 'package:todos_example/models/product_model.dart';
import 'package:todos_example/models/store_api.dart';

class ProductPage extends StatelessWidget {
  final StoreApi api;

  const ProductPage({super.key, required this.api});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: api.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }

        final products = snapshot.data!;
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
    );
  }
}
