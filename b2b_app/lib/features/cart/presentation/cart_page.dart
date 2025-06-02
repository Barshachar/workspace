import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/cart_controller.dart';
import '../../checkout/presentation/checkout_page.dart';
import '../../../core/models/order_item.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('עגלה')),
      body: cart.when(
        data: (items) => _CartList(items: items),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('שגיאה')),
      ),
    );
  }
}

class _CartList extends ConsumerWidget {
  final List<OrderItem> items;
  const _CartList({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = items.fold<double>(0, (t, e) => t + e.price * e.quantity);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Dismissible(
                key: ValueKey(item.productId),
                onDismissed: (_) =>
                    ref.read(cartControllerProvider.notifier).removeItem(item.productId),
                child: ListTile(
                  title: Text(item.productId),
                  subtitle: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          final qty = item.quantity - 1;
                          if (qty > 0) {
                            ref
                                .read(cartControllerProvider.notifier)
                                .updateQty(item.productId, qty);
                          }
                        },
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          ref
                              .read(cartControllerProvider.notifier)
                              .updateQty(item.productId, item.quantity + 1);
                        },
                      ),
                    ],
                  ),
                  trailing: Text('${item.price * item.quantity} ₪'),
                ),
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
                onPressed: () async {
                  final id =
                      await ref.read(cartControllerProvider.notifier).checkout(total);
                  if (id != null && context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CheckoutPage(orderId: id, amount: total),
                      ),
                    );
                  }
                },
                child: const Text('לתשלום'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
