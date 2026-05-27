// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      customerName: json['customerName'] as String? ?? '',
      customerId: json['customerId'] as String?,
      status: json['status'] as String,
      orderType: json['orderType'] as String? ?? 'dine-in',
      tableNumber: json['tableNumber'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String? ?? '',
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'customerName': instance.customerName,
      'customerId': instance.customerId,
      'status': instance.status,
      'orderType': instance.orderType,
      'tableNumber': instance.tableNumber,
      'totalAmount': instance.totalAmount,
      'notes': instance.notes,
      'createdAt': instance.createdAt,
    };
