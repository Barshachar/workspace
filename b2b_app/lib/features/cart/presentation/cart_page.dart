import 'package:flutter/material.dart';
import '../../../core/models/order_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      const OrderItem(productId: '1', quantity: 1, price: 10),
    ];
    final total = items.fold<double>(0, (t, e) => t + e.price * e.quantity);
    return Scaffold(
      appBar: AppBar(title: const Text('עגלה')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.productId),
                  trailing: Text('${item.price * item.quantity} ₪'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('סה"כ: $total ₪'),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('לתשלום'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
