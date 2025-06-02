import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/order_item.dart';

class CartRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<List<OrderItem>> watch(String userId) {
    final stream = _client
        .from('cart_items')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((rows) => rows
            .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList());
    stream.listen((items) async {
      final box = await Hive.openBox('cart');
      await box.put('items', items.map((e) => e.toJson()).toList());
    });
    return stream.handleError((_) async {
      final box = await Hive.openBox('cart');
      final cached = box.get('items') as List?;
      if (cached != null) {
        return cached
            .map((e) => OrderItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    });
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
