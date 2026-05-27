import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@freezed
class CustomerModel with _$CustomerModel {
  const factory CustomerModel({
    required String id,
    required String name,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String internalNotes,
    @Default(0.0) double outstandingDebt,
    @Default(0) int ordersCount,
    @Default(0) int invoicesCount,
    String? createdAt,
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);
}
