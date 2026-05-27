// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerModelImpl _$$CustomerModelImplFromJson(Map<String, dynamic> json) =>
    _$CustomerModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      internalNotes: json['internalNotes'] as String? ?? '',
      outstandingDebt: (json['outstandingDebt'] as num?)?.toDouble() ?? 0.0,
      ordersCount: (json['ordersCount'] as num?)?.toInt() ?? 0,
      invoicesCount: (json['invoicesCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$CustomerModelImplToJson(_$CustomerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'internalNotes': instance.internalNotes,
      'outstandingDebt': instance.outstandingDebt,
      'ordersCount': instance.ordersCount,
      'invoicesCount': instance.invoicesCount,
      'createdAt': instance.createdAt,
    };
