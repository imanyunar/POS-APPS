import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

@freezed
class InvoiceModel with _$InvoiceModel {
  const factory InvoiceModel({
    required String id,
    required String invoiceNumber,
    @Default('') String customerName,
    String? customerId,
    String? orderId,
    required String status,
    @Default(0.0) double subtotal,
    @Default(0.0) double tax,
    @Default(0.0) double total,
    String? dueDate,
    String? createdAt,
  }) = _InvoiceModel;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);
}
