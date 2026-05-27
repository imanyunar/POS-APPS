import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_model.freezed.dart';
part 'inventory_model.g.dart';

@freezed
class InventoryModel with _$InventoryModel {
  const factory InventoryModel({
    required String id,
    required String name,
    @Default('') String sku,
    @Default(0) int quantity,
    @Default(0.0) double unitPrice,
    @Default('pcs') String unit,
    @Default('in_stock') String status,
    @Default(5) int lowStockThreshold,
    String? createdAt,
  }) = _InventoryModel;

  factory InventoryModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryModelFromJson(json);
}
