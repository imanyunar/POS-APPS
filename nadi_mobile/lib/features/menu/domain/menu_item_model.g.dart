// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MenuItemModelImpl _$$MenuItemModelImplFromJson(Map<String, dynamic> json) =>
    _$MenuItemModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      estimatedPrepMinutes:
          (json['estimatedPrepMinutes'] as num?)?.toInt() ?? 5,
      trackStock: json['trackStock'] as bool? ?? false,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
      lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt() ?? 5,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$MenuItemModelImplToJson(_$MenuItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
      'isAvailable': instance.isAvailable,
      'estimatedPrepMinutes': instance.estimatedPrepMinutes,
      'trackStock': instance.trackStock,
      'stockQuantity': instance.stockQuantity,
      'lowStockThreshold': instance.lowStockThreshold,
      'createdAt': instance.createdAt,
    };
