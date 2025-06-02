import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/product.dart';

class RecommendationRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Product>> fetchForCustomer(String customerId) async {
    final resp = await _client.functions.invoke('recommend-products', body: {
      'customer_id': customerId,
    });
    final data = resp.data as List<dynamic>? ?? [];
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
