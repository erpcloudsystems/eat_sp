import '../global/global_variables.dart';
import '../resources/app_values.dart';

class ApiConstance {
  // Here we get the base URL from the old version service.
  static String baseUrl = GlobalVariables().getBaseUrl;

// the page length the sent in query for pagination.
  static const pageLength = 25;

  static const connectionTimeOut = Duration(seconds: IntManager.i_15);
  static const receiveTimeOut = Duration(seconds: IntManager.i_30);

  /// Here we use this getter to give it a docType name and it return with full end point for (General 'get' call) in the API
  static String generalGet({required String docType, required int startKey}) =>
      'method/ecs_mobile.general.general_service?start=$startKey&doctype=$docType&page_length=2';

  static const String getWarehouseReports =
      'method/ecs_mobile.reports.stock.warehouse_balance';

  static const String getReports = 'method/ecs_mobile.general.get_reports';

  static const String getStockLedgerReport =
      'method/ecs_mobile.reports.stock.stock_ledger';

  static const String getItemPriceReport =
      'method/ecs_mobile.reports.stock.item_price';

  static const String getGeneralLedgerReport =
      'method/ecs_mobile.reports.accounts.general_ledger';
}
