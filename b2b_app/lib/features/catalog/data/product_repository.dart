import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/product.dart';

class ProductRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<List<Product>> watch(String query, int limit, int offset) {
    final builder = _client
        .from('products')
        .select()
        .ilike('name', '%$query%')
        .eq('is_active', true)
        .range(offset, offset + limit - 1)
        .order('name');
    final stream = builder
        .withConverter((rows) =>
            rows.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList())
        .stream();
    stream.listen((data) async {
      final box = await Hive.openBox('catalog');
      await box.put('list', data.map((e) => e.toJson()).toList());
    });
    return stream.handleError((_) async {
      final box = await Hive.openBox('catalog');
      final cached = box.get('list') as List?;
      if (cached != null) {
        return cached
            .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    });
  }

  Future<double> resolvePrice(String sku, String customerId, double basePrice) async {
    final resp = await _client.functions.invoke('resolve-price', body: {
      'sku': sku,
      'customer_id': customerId,
      'base_price': basePrice,
    });
    final data = resp.data as Map<String, dynamic>?;
    return data?['price']?.toDouble() ?? basePrice;
  }
}
