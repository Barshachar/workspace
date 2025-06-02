import 'package:flutter/material.dart';
import '../../../core/models/product.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      const Product(id: '1', name: 'מוצר א', price: 10),
      const Product(id: '2', name: 'מוצר ב', price: 20),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('קטלוג')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'חיפוש'),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(product.name),
                      Text('${product.price} ₪'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
