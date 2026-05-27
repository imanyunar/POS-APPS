// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityModelImpl _$$ActivityModelImplFromJson(Map<String, dynamic> json) =>
    _$ActivityModelImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      details: json['details'] as Map<String, dynamic>?,
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$ActivityModelImplToJson(_$ActivityModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'details': instance.details,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'createdAt': instance.createdAt,
    };
