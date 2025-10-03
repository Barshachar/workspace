import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'quantity') required int quantity,
    @JsonKey(name: 'price', fromJson: _doubleFromJson, toJson: _doubleToJson)
        required double price,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
}

double _doubleFromJson(Object? value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.parse(value.toString());
}

Object _doubleToJson(double value) => value;
