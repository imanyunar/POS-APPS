import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_vitals.freezed.dart';
part 'dashboard_vitals.g.dart';

@freezed
class DashboardVitals with _$DashboardVitals {
  const factory DashboardVitals({
    @Default(0.0) double todayRevenue,
    @Default(0) int activeOrdersCount,
    @Default(0) int pendingInvoicesCount,
    @Default(0.0) double pendingInvoicesAmount,
    @Default(0) int lowStockCount,
    @Default(0) int todayTasksCompleted,
  }) = _DashboardVitals;

  factory DashboardVitals.fromJson(Map<String, dynamic> json) =>
      _$DashboardVitalsFromJson(json);
}
