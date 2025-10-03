// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'order_item.dart';

T _$identity<T>(T value) => value;

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

mixin _$OrderItem {
  String? get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderItemCopyWith<OrderItem> get copyWith => throw _privateConstructorUsedError;
}

abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) = _$OrderItemCopyWithImpl<$Res>;
  $Res call({String? id, String productId, int quantity, double price});
}

class _$OrderItemCopyWithImpl<$Res> implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);
  final OrderItem _value;
  final $Res Function(OrderItem) _then;

  @override
  $Res call({Object? id = freezed, Object? productId = freezed, Object? quantity = freezed, Object? price = freezed}) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String?,
      productId: productId == freezed ? _value.productId : productId as String,
      quantity: quantity == freezed ? _value.quantity : quantity as int,
      price: price == freezed ? _value.price : price as double,
    ));
  }
}

abstract class _$$_OrderItemCopyWith<$Res> implements $OrderItemCopyWith<$Res> {
  factory _$$_OrderItemCopyWith(_OrderItem value, $Res Function(_OrderItem) then) = __$$_OrderItemCopyWithImpl<$Res>;
  @override
  $Res call({String? id, String productId, int quantity, double price});
}

class __$$_OrderItemCopyWithImpl<$Res> extends _$OrderItemCopyWithImpl<$Res> implements _$$_OrderItemCopyWith<$Res> {
  __$$_OrderItemCopyWithImpl(_OrderItem _value, $Res Function(_OrderItem) _then) : super(_value, (v) => _then(v as _OrderItem));

  @override
  _OrderItem get _value => super._value as _OrderItem;

  @override
  $Res call({Object? id = freezed, Object? productId = freezed, Object? quantity = freezed, Object? price = freezed}) {
    return _then(_OrderItem(
      id: id == freezed ? _value.id : id as String?,
      productId: productId == freezed ? _value.productId : productId as String,
      quantity: quantity == freezed ? _value.quantity : quantity as int,
      price: price == freezed ? _value.price : price as double,
    ));
  }
}

@JsonSerializable()
class _$_OrderItem implements _OrderItem {
  const _$_OrderItem({this.id, required this.productId, required this.quantity, required this.price});

  factory _$_OrderItem.fromJson(Map<String, dynamic> json) => _$$_OrderItemFromJson(json);

  @override
  final String? id;
  @override
  final String productId;
  @override
  final int quantity;
  @override
  final double price;

  @override
  String toString() {
    return 'OrderItem(id: $id, productId: $productId, quantity: $quantity, price: $price)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _OrderItem && other.id == id && other.productId == productId && other.quantity == quantity && other.price == price);
  }

  @override
  int get hashCode => Object.hash(id, productId, quantity, price);

  @JsonKey(ignore: true)
  @override
  _$$_OrderItemCopyWith<_OrderItem> get copyWith => __$$_OrderItemCopyWithImpl<_OrderItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OrderItemToJson(this);
  }
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem({String? id, required String productId, required int quantity, required double price}) = _$_OrderItem;

  factory _OrderItem.fromJson(Map<String, dynamic> json) = _$_OrderItem.fromJson;

  @override
  String? get id;
  @override
  String get productId;
  @override
  int get quantity;
  @override
  double get price;
  @override
  @JsonKey(ignore: true)
  _$$_OrderItemCopyWith<_OrderItem> get copyWith => throw _privateConstructorUsedError;
}
