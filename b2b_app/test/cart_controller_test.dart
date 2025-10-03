import 'dart:async';

import 'package:b2b_app/core/models/order_item.dart';
import 'package:b2b_app/features/cart/data/cart_repository.dart';
import 'package:b2b_app/features/cart/logic/cart_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeCartRepository extends CartRepository {
  _FakeCartRepository(this._controller);

  final StreamController<List<OrderItem>> _controller;

  @override
  Stream<List<OrderItem>> watch(String userId) {
    return _controller.stream;
  }
}

void main() {
  test('CartController build resolves with first cart items', () async {
    Supabase.instance.initialize(url: 'u', anonKey: 'k');
    Supabase.instance.client = SupabaseClient('u', 'k');

    final controller = StreamController<List<OrderItem>>();
    final repo = _FakeCartRepository(controller);

    final container = ProviderContainer(overrides: [
      cartRepositoryProvider.overrideWithValue(repo),
      cartUserIdProvider.overrideWithValue('user-123'),
    ]);

    addTearDown(() async {
      await controller.close();
      container.dispose();
    });

    final future = container.read(cartControllerProvider.future);

    final items = [
      const OrderItem(productId: 'p1', quantity: 1, price: 1.0),
      const OrderItem(productId: 'p2', quantity: 2, price: 3.0),
    ];

    controller.add(items);

    final initialItems = await future;
    expect(initialItems, items);
    expect(container.read(cartControllerProvider).value, items);
  });
}
