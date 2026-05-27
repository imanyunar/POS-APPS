// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryModelImpl _$$InventoryModelImplFromJson(Map<String, dynamic> json) =>
    _$InventoryModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? 'pcs',
      status: json['status'] as String? ?? 'in_stock',
      lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt() ?? 5,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$InventoryModelImplToJson(
        _$InventoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'unit': instance.unit,
      'status': instance.status,
      'lowStockThreshold': instance.lowStockThreshold,
      'createdAt': instance.createdAt,
    };
