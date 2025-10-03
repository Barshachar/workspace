import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/order_item.dart';

class CartRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<List<OrderItem>> watch(String userId) {
    final source = _client
        .from('cart_items')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((rows) => rows
            .map((e) =>
                OrderItem.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList());
    final controller = StreamController<List<OrderItem>>();

    Future<Box> openBox() async {
      if (Hive.isBoxOpen('cart')) {
        return Hive.box('cart');
      }
      return Hive.openBox('cart');
    }

    Future<bool> emitCached() async {
      try {
        final box = await openBox();
        final cached = box.get('items') as List?;
        if (cached != null) {
          final items = cached
              .map((e) =>
                  OrderItem.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList();
          controller.add(items);
          return true;
        }
      } catch (_) {}
      return false;
    }

    final subscription = source.listen((items) async {
      controller.add(items);
      try {
        final box = await openBox();
        await box.put('items', items.map((e) => e.toJson()).toList());
      } catch (_) {}
    }, onError: (error, stackTrace) async {
      final emitted = await emitCached();
      if (!emitted) {
        controller.addError(error, stackTrace);
      }
    }, onDone: () async {
      if (!controller.isClosed) {
        await controller.close();
      }
    });

    controller
      ..onPause = () => subscription.pause()
      ..onResume = () => subscription.resume()
      ..onCancel = () async {
        await subscription.cancel();
        if (!controller.isClosed) {
          await controller.close();
        }
      };

    return controller.stream;
  }

  Future<void> add(String userId, OrderItem item) async {
    await _client.from('cart_items').insert({
      'user_id': userId,
      'product_id': item.productId,
      'quantity': item.quantity,
      'price': item.price,
    });
  }

  Future<void> updateQty(String id, int qty) async {
    await _client.from('cart_items').update({'quantity': qty}).eq('id', id);
  }

  Future<void> remove(String id) async {
    await _client.from('cart_items').delete().eq('id', id);
  }

  Future<void> clear(String userId) async {
    await _client.from('cart_items').delete().eq('user_id', userId);
  }

  Future<String?> checkout(String userId, double total) async {
    final resp = await _client.rpc('create_order', params: {'total': total});
    await clear(userId);
    return (resp as Map<String, dynamic>?)?['order_id'] as String?;
  }
}
