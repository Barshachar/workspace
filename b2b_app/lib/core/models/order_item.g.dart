// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'order_item.dart';

_$_OrderItem _$$_OrderItemFromJson(Map<String, dynamic> json) => _$_OrderItem(
      id: json['id'] as String?,
      productId: json['product_id'] as String,
      quantity: json['quantity'] as int,
      price: _doubleFromJson(json['price']),
    );

Map<String, dynamic> _$$_OrderItemToJson(_$_OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'price': _doubleToJson(instance.price),
    };
