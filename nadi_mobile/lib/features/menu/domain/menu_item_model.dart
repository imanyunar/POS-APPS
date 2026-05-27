import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item_model.freezed.dart';
part 'menu_item_model.g.dart';

@freezed
class MenuItemModel with _$MenuItemModel {
  const factory MenuItemModel({
    required String id,
    required String name,
    @Default('') String description,
    required double price,
    required String category,
    @Default(true) bool isAvailable,
    @Default(5) int estimatedPrepMinutes,
    @Default(false) bool trackStock,
    @Default(0) int stockQuantity,
    @Default(5) int lowStockThreshold,
    String? createdAt,
  }) = _MenuItemModel;

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);
}
