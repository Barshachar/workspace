import 'package:flutter_test/flutter_test.dart';
import 'package:b2b_app/core/models/product.dart';

void main() {
  group('Product', () {
    test('serializes and deserializes consistently', () {
      const product = Product(
        id: 'p-1',
        name: 'Widget',
        price: 12.5,
        sku: 'WIDGET-001',
        imageUrl: 'https://example.com/widget.png',
      );

      final json = product.toJson();
      final restored = Product.fromJson(json);

      expect(json, containsPair('id', 'p-1'));
      expect(json, containsPair('sku', 'WIDGET-001'));
      expect(restored, equals(product));
    });

    test('defaults optional fields to null when missing in json', () {
      final restored = Product.fromJson({
        'id': 'p-2',
        'name': 'Basic Widget',
        'price': 7.0,
      });

      expect(restored.sku, isNull);
      expect(restored.imageUrl, isNull);
    });
  });
}
