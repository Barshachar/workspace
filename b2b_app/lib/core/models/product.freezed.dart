// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'product.dart';

T _$identity<T>(T value) => value;

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) = _$ProductCopyWithImpl<$Res>;
  $Res call({String id, String name, double price});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res> implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  final Product _value;
  // ignore: unused_field
  final $Res Function(Product) _then;

  @override
  $Res call({Object? id = freezed, Object? name = freezed, Object? price = freezed}) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      name: name == freezed ? _value.name : name as String,
      price: price == freezed ? _value.price : price as double,
    ));
  }
}

/// @nodoc
abstract class _$$_ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$_ProductCopyWith(_Product value, $Res Function(_Product) then) = __$$_ProductCopyWithImpl<$Res>;
  @override
  $Res call({String id, String name, double price});
}

/// @nodoc
class __$$_ProductCopyWithImpl<$Res> extends _$ProductCopyWithImpl<$Res> implements _$$_ProductCopyWith<$Res> {
  __$$_ProductCopyWithImpl(_Product _value, $Res Function(_Product) _then) : super(_value, (v) => _then(v as _Product));

  @override
  _Product get _value => super._value as _Product;

  @override
  $Res call({Object? id = freezed, Object? name = freezed, Object? price = freezed}) {
    return _then(_Product(
      id: id == freezed ? _value.id : id as String,
      name: name == freezed ? _value.name : name as String,
      price: price == freezed ? _value.price : price as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Product implements _Product {
  const _$_Product({required this.id, required this.name, required this.price});

  factory _$_Product.fromJson(Map<String, dynamic> json) => _$$_ProductFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double price;

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Product && (identical(other.id, id) || other.id == id) && (identical(other.name, name) || other.name == name) && (identical(other.price, price) || other.price == price));
  }

  @override
  int get hashCode => Object.hash(id, name, price);

  @JsonKey(ignore: true)
  @override
  _$$_ProductCopyWith<_Product> get copyWith => __$$_ProductCopyWithImpl<_Product>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProductToJson(this);
  }
}

abstract class _Product implements Product {
  const factory _Product({required String id, required String name, required double price}) = _$_Product;

  factory _Product.fromJson(Map<String, dynamic> json) = _$_Product.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get price;
  @override
  @JsonKey(ignore: true)
  _$$_ProductCopyWith<_Product> get copyWith => throw _privateConstructorUsedError;
}
