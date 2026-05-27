// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_vitals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardVitalsImpl _$$DashboardVitalsImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardVitalsImpl(
      todayRevenue: (json['todayRevenue'] as num?)?.toDouble() ?? 0.0,
      activeOrdersCount: (json['activeOrdersCount'] as num?)?.toInt() ?? 0,
      pendingInvoicesCount:
          (json['pendingInvoicesCount'] as num?)?.toInt() ?? 0,
      pendingInvoicesAmount:
          (json['pendingInvoicesAmount'] as num?)?.toDouble() ?? 0.0,
      lowStockCount: (json['lowStockCount'] as num?)?.toInt() ?? 0,
      todayTasksCompleted: (json['todayTasksCompleted'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DashboardVitalsImplToJson(
        _$DashboardVitalsImpl instance) =>
    <String, dynamic>{
      'todayRevenue': instance.todayRevenue,
      'activeOrdersCount': instance.activeOrdersCount,
      'pendingInvoicesCount': instance.pendingInvoicesCount,
      'pendingInvoicesAmount': instance.pendingInvoicesAmount,
      'lowStockCount': instance.lowStockCount,
      'todayTasksCompleted': instance.todayTasksCompleted,
    };
