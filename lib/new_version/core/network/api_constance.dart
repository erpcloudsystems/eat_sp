import '../global/global_variables.dart';

class ApiConstance {
  // Here we get the base URL from the old version service.
  static String baseUrl = GlobalVariables().getBaseUrl;

// the page length the sent in query for pagination.
  static const pageLength = 20;

  /// Here we use this getter to give it a docType name and it return with full end point for (General 'get' call) in the API
  static String generalGet({required String docType, required int startKey}) =>
      'method/ecs_mobile.general.general_service?start=$startKey&doctype=$docType&page_length=2';

  static String getWarehouseReports =
      'method/ecs_mobile.reports.stock.warehouse_balance';

  static String getReports = 'method/ecs_mobile.general.get_reports';

  static String getStockLedgerReport = 'method/ecs_mobile.reports.stock.stock_ledger';

  static String getItemPriceReport = 'method/ecs_mobile.reports.stock.item_price';

  static String getGeneralLedgerReport = 'method/ecs_mobile.reports.accounts.general_ledger';
}
