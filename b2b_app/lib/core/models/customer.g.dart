// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'customer.dart';

_$_Customer _$$_CustomerFromJson(Map<String, dynamic> json) => _$_Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      creditLimit: (json['creditLimit'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$_CustomerToJson(_$_Customer instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'creditLimit': instance.creditLimit,
    };
