// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'order.dart';

_$_Order _$$_OrderFromJson(Map<String, dynamic> json) => _$_Order(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      invoiceUrl: json['invoiceUrl'] as String?,
    );

Map<String, dynamic> _$$_OrderToJson(_$_Order instance) => <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'invoiceUrl': instance.invoiceUrl,
    };
