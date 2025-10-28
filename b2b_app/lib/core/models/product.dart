import 'package:flutter/foundation.dart';

@immutable
class Product {
  final String id;
  final String name;
  final double price;
  final String? sku;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.sku,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      sku: json['sku'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'price': price,
        'sku': sku,
        'imageUrl': imageUrl,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
       other.id == id &&
       other.name == name &&
       other.price == price &&
       other.sku == sku &&
       other.imageUrl == imageUrl);

  @override
  int get hashCode => Object.hash(id, name, price, sku, imageUrl);

  @override
  String toString() =>
      'Product(id: $id, name: $name, price: $price, sku: $sku, imageUrl: $imageUrl)';
}
