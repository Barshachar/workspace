import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String customerId,
    required List<OrderItem> items,
    required double total,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
