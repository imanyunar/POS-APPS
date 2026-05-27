import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String orderNumber,
    @Default('') String customerName,
    String? customerId,
    required String status,
    @Default('dine-in') String orderType,
    String? tableNumber,
    @Default(0.0) double totalAmount,
    @Default('') String notes,
    String? createdAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}
