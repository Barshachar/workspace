// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'customer.dart';

T _$identity<T>(T value) => value;

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return _Customer.fromJson(json);
}

mixin _$Customer {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  double? get creditLimit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomerCopyWith<Customer> get copyWith => throw _privateConstructorUsedError;
}

abstract class $CustomerCopyWith<$Res> {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) then) = _$CustomerCopyWithImpl<$Res>;
  $Res call({String id, String name, String email, double? creditLimit});
}

class _$CustomerCopyWithImpl<$Res> implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._value, this._then);

  final Customer _value;
  final $Res Function(Customer) _then;

  @override
  $Res call({Object? id = freezed, Object? name = freezed, Object? email = freezed, Object? creditLimit = freezed}) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      name: name == freezed ? _value.name : name as String,
      email: email == freezed ? _value.email : email as String,
      creditLimit: creditLimit == freezed ? _value.creditLimit : creditLimit as double?,
    ));
  }
}

abstract class _$$_CustomerCopyWith<$Res> implements $CustomerCopyWith<$Res> {
  factory _$$_CustomerCopyWith(_Customer value, $Res Function(_Customer) then) = __$$_CustomerCopyWithImpl<$Res>;
  @override
  $Res call({String id, String name, String email, double? creditLimit});
}

class __$$_CustomerCopyWithImpl<$Res> extends _$CustomerCopyWithImpl<$Res> implements _$$_CustomerCopyWith<$Res> {
  __$$_CustomerCopyWithImpl(_Customer _value, $Res Function(_Customer) _then) : super(_value, (v) => _then(v as _Customer));

  @override
  _Customer get _value => super._value as _Customer;

  @override
  $Res call({Object? id = freezed, Object? name = freezed, Object? email = freezed, Object? creditLimit = freezed}) {
    return _then(_Customer(
      id: id == freezed ? _value.id : id as String,
      name: name == freezed ? _value.name : name as String,
      email: email == freezed ? _value.email : email as String,
      creditLimit: creditLimit == freezed ? _value.creditLimit : creditLimit as double?,
    ));
  }
}

@JsonSerializable()
class _$_Customer implements _Customer {
  const _$_Customer({required this.id, required this.name, required this.email, this.creditLimit});

  factory _$_Customer.fromJson(Map<String, dynamic> json) => _$$_CustomerFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final double? creditLimit;

  @override
  String toString() {
    return 'Customer(id: $id, name: $name, email: $email, creditLimit: $creditLimit)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Customer && other.id == id && other.name == name && other.email == email && other.creditLimit == creditLimit);
  }

  @override
  int get hashCode => Object.hash(id, name, email, creditLimit);

  @JsonKey(ignore: true)
  @override
  _$$_CustomerCopyWith<_Customer> get copyWith => __$$_CustomerCopyWithImpl<_Customer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CustomerToJson(this);
  }
}

abstract class _Customer implements Customer {
  const factory _Customer({required String id, required String name, required String email, double? creditLimit}) = _$_Customer;

  factory _Customer.fromJson(Map<String, dynamic> json) = _$_Customer.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  double? get creditLimit;
  @override
  @JsonKey(ignore: true)
  _$$_CustomerCopyWith<_Customer> get copyWith => throw _privateConstructorUsedError;
}
