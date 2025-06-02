import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/product_repository.dart';
import '../../../core/models/product.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) => ProductRepository());

class CatalogPage extends ConsumerStatefulWidget {
  const CatalogPage({super.key});

  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage> {
  String query = '';
  int page = 0;
  static const pageSize = 20;

  @override
  Widget build(BuildContext context) {
    final stream = ref.watch(productRepositoryProvider).watch(query, pageSize, page * pageSize);
    return Scaffold(
      appBar: AppBar(title: const Text('קטלוג')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'חיפוש'),
              onChanged: (v) => setState(() {
                query = v;
                page = 0;
              }),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>( 
              stream: stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final products = snapshot.data!;
                return NotificationListener<ScrollEndNotification>(
                  onNotification: (n) {
                    if (n.metrics.pixels == n.metrics.maxScrollExtent) {
                      setState(() => page++);
                    }
                    return false;
                  },
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
                            if (product.imageUrl != null)
                              CachedNetworkImage(
                                imageUrl: product.imageUrl!,
                                width: 80,
                                height: 80,
                              ),
                            Text(product.name),
                            Text('${product.price} ₪'),
                          ],
                        ),
                      );
                    },
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
