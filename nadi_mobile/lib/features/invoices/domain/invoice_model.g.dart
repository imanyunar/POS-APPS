// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceModelImpl _$$InvoiceModelImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceModelImpl(
      id: json['id'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      customerName: json['customerName'] as String? ?? '',
      customerId: json['customerId'] as String?,
      orderId: json['orderId'] as String?,
      status: json['status'] as String,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      dueDate: json['dueDate'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$InvoiceModelImplToJson(_$InvoiceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoiceNumber': instance.invoiceNumber,
      'customerName': instance.customerName,
      'customerId': instance.customerId,
      'orderId': instance.orderId,
      'status': instance.status,
      'subtotal': instance.subtotal,
      'tax': instance.tax,
      'total': instance.total,
      'dueDate': instance.dueDate,
      'createdAt': instance.createdAt,
    };
