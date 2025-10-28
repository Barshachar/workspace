import 'package:flutter_test/flutter_test.dart';
import 'package:b2b_app/core/models/product.dart';

void main() {
  test('Product serializes and deserializes consistently', () {
    const product = Product(
      id: 'p-1',
      name: 'Widget',
      price: 12.5,
      sku: 'WIDGET-001',
      imageUrl: 'https://example.com/widget.png',
    );

    final json = product.toJson();
    final restored = Product.fromJson(json);

    expect(restored, equals(product));
  });

  test('Product.fromJson defaults optional fields to null', () {
    final restored = Product.fromJson({
      'id': 'p-2',
      'name': 'Basic Widget',
      'price': 7.0,
    });

    expect(restored.sku, isNull);
    expect(restored.imageUrl, isNull);
  });
}
