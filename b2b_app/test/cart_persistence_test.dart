import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:b2b_app/features/cart/logic/cart_controller.dart';
import 'package:b2b_app/core/models/order_item.dart';

class FakeClient extends SupabaseClient {
  FakeClient() : super('url', 'key');
  final List<Map<String, dynamic>> items = [];
  @override
  SupabaseQueryBuilder from(String table) {
    return _FakeQueryBuilder(items);
  }
}

class _FakeQueryBuilder extends SupabaseQueryBuilder {
  final List<Map<String, dynamic>> items;
  _FakeQueryBuilder(this.items) : super('cart_items', SupabaseClient('u','k'));
  @override
  Stream<List<Map<String, dynamic>>> stream({String? primaryKey}) {
    return Stream.value(items);
  }

  @override
  Future<PostgrestResponse> insert(dynamic values, {bool? upsert, String? onConflict, bool ignoreDuplicates = false}) async {
    items.add(values as Map<String, dynamic>);
    return PostgrestResponse(data: null, error: null, count: null, status: 201);
  }
}

void main() {
  test('cart watch emits items', () async {
    final client = FakeClient();
    Supabase.instance.initialize(url: 'u', anonKey: 'k');
    Supabase.instance.client = client;
    final repo = CartRepository();
    final stream = repo.watch('u1');
    await repo.add('u1', const OrderItem(productId: 'p1', quantity: 1, price: 2));
    final items = await stream.first;
    expect(items, hasLength(1));
  });
}
