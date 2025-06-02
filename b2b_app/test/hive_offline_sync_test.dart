import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:b2b_app/core/models/product.dart';

void main() {
  test('load catalog from cache', () async {
    final dir = Directory.systemTemp.createTempSync();
    Hive.init(dir.path);
    final box = await Hive.openBox('catalog');
    await box.put('list', [
      {'id': '1', 'name': 'demo', 'price': 1.0}
    ]);
    final cached = box.get('list') as List;
    final products = cached.map((e) => Product.fromJson(Map<String, dynamic>.from(e))).toList();
    expect(products, isNotEmpty);
    await box.close();
    dir.deleteSync(recursive: true);
  });
}
