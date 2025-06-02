// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'order.dart';

T _$identity<T>(T value) => value;

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

mixin _$Order {
  String get id => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  List<OrderItem> get items => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String? get invoiceUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) = _$OrderCopyWithImpl<$Res>;
  $Res call({String id, String customerId, List<OrderItem> items, double total, String? invoiceUrl});
}

class _$OrderCopyWithImpl<$Res> implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);
  final Order _value;
  final $Res Function(Order) _then;

  @override
  $Res call({Object? id = freezed, Object? customerId = freezed, Object? items = freezed, Object? total = freezed, Object? invoiceUrl = freezed}) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      customerId: customerId == freezed ? _value.customerId : customerId as String,
      items: items == freezed ? _value.items : items as List<OrderItem>,
      total: total == freezed ? _value.total : total as double,
      invoiceUrl: invoiceUrl == freezed ? _value.invoiceUrl : invoiceUrl as String?,
    ));
  }
}

abstract class _$$_OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$_OrderCopyWith(_Order value, $Res Function(_Order) then) = __$$_OrderCopyWithImpl<$Res>;
  @override
  $Res call({String id, String customerId, List<OrderItem> items, double total, String? invoiceUrl});
}

class __$$_OrderCopyWithImpl<$Res> extends _$OrderCopyWithImpl<$Res> implements _$$_OrderCopyWith<$Res> {
  __$$_OrderCopyWithImpl(_Order _value, $Res Function(_Order) _then) : super(_value, (v) => _then(v as _Order));

  @override
  _Order get _value => super._value as _Order;

  @override
  $Res call({Object? id = freezed, Object? customerId = freezed, Object? items = freezed, Object? total = freezed, Object? invoiceUrl = freezed}) {
    return _then(_Order(
      id: id == freezed ? _value.id : id as String,
      customerId: customerId == freezed ? _value.customerId : customerId as String,
      items: items == freezed ? _value.items : items as List<OrderItem>,
      total: total == freezed ? _value.total : total as double,
      invoiceUrl: invoiceUrl == freezed ? _value.invoiceUrl : invoiceUrl as String?,
    ));
  }
}

@JsonSerializable(explicitToJson: true)
class _$_Order implements _Order {
  const _$_Order({required this.id, required this.customerId, required this.items, required this.total, this.invoiceUrl});

  factory _$_Order.fromJson(Map<String, dynamic> json) => _$$_OrderFromJson(json);

  @override
  final String id;
  @override
  final String customerId;
  @override
  final List<OrderItem> items;
  @override
  final double total;
  @override
  final String? invoiceUrl;

  @override
  String toString() {
    return 'Order(id: $id, customerId: $customerId, items: $items, total: $total, invoiceUrl: $invoiceUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Order && other.id == id && other.customerId == customerId && const DeepCollectionEquality().equals(other.items, items) && other.total == total && other.invoiceUrl == invoiceUrl);
  }

  @override
  int get hashCode => Object.hash(id, customerId, const DeepCollectionEquality().hash(items), total, invoiceUrl);

  @JsonKey(ignore: true)
  @override
  _$$_OrderCopyWith<_Order> get copyWith => __$$_OrderCopyWithImpl<_Order>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OrderToJson(this);
  }
}

abstract class _Order implements Order {
  const factory _Order({required String id, required String customerId, required List<OrderItem> items, required double total, String? invoiceUrl}) = _$_Order;

  factory _Order.fromJson(Map<String, dynamic> json) = _$_Order.fromJson;

  @override
  String get id;
  @override
  String get customerId;
  @override
  List<OrderItem> get items;
  @override
  double get total;
  @override
  String? get invoiceUrl;
  @override
  @JsonKey(ignore: true)
  _$$_OrderCopyWith<_Order> get copyWith => throw _privateConstructorUsedError;
}
