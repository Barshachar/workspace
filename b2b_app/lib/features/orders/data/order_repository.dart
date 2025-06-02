import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) => OrderRepository());

class OrderRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> markPaid(String orderId) async {
    await _client.from('orders').update({'status': 'paid'}).eq('id', orderId);
  }
}
