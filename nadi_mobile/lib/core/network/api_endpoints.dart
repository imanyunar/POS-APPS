class ApiEndpoints {
  ApiEndpoints._();

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String switchWorkspace = '/auth/switch-workspace';

  static const String dashboardVitals = '/dashboard/vitals';
  static const String dashboardActivities = '/dashboard/activities';

  static const String customers = '/customers';
  static String customerDetail(String id) => '/customers/$id';
  static String customerOrders(String id) => '/customers/$id/orders';
  static String customerInvoices(String id) => '/customers/$id/invoices';
  static String customerTimeline(String id) => '/customers/$id/timeline';

  static const String orders = '/orders';
  static String orderDetail(String id) => '/orders/$id';
  static String orderStatus(String id) => '/orders/$id/status';

  static const String invoices = '/invoices';
  static String invoiceDetail(String id) => '/invoices/$id';
  static String invoiceMarkPaid(String id) => '/invoices/$id/mark-paid';

  static const String menuItems = '/menu-items';
  static String menuItemDetail(String id) => '/menu-items/$id';
  static String menuItemToggleAvailability(String id) => '/menu-items/$id/toggle-availability';

  static const String inventory = '/inventory';
  static String inventoryDetail(String id) => '/inventory/$id';
  static const String inventoryLowStock = '/inventory/low-stock';

  static const String tasks = '/tasks';
  static String taskDetail(String id) => '/tasks/$id';
  static String taskToggle(String id) => '/tasks/$id/toggle';

  static const String notes = '/notes';
  static String noteDetail(String id) => '/notes/$id';

  static const String activities = '/dashboard/activities';

  // Payments
  static const String paymentCreateLink = '/payments/create-link';
  static String paymentStatus(String invoiceId) => '/payments/$invoiceId/status';
}
