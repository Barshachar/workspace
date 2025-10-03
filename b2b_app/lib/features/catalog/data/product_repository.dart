import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final source = builder
        .withConverter((rows) =>
            rows.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList())
        .stream();
    final controller = StreamController<List<Product>>();

    Future<Box> openBox() async {
      if (Hive.isBoxOpen('catalog')) {
        return Hive.box('catalog');
      }
      return Hive.openBox('catalog');
    }

    Future<bool> emitCached() async {
      try {
        final box = await openBox();
        final cached = box.get('list') as List?;
        if (cached != null) {
          final products = cached
              .map((e) =>
                  Product.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList();
          controller.add(products);
          return true;
        }
      } catch (_) {}
      return false;
    }

    final subscription = source.listen((data) async {
      controller.add(data);
      try {
        final box = await openBox();
        await box.put('list', data.map((e) => e.toJson()).toList());
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
