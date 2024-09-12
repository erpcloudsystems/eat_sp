import '../global/global_variables.dart';
import '../resources/app_values.dart';

class ApiConstance {
  // Here we get the base URL from the old version service.
  static String baseUrl = GlobalVariables().getBaseUrl;

// the page length the sent in query for pagination.
  static const pageLength = 20;

  static const connectionTimeOut = Duration(seconds: IntManager.i_15);
  static const receiveTimeOut = Duration(seconds: IntManager.i_30);

  /// Here we use this getter to give it a docType name and it return with full end point for (General 'get' call) in the API
  static String generalGet({required String docType, required int startKey}) =>
      'method/elkhabaz_mobile.general.general_service?start=$startKey&doctype=$docType&page_length=2';

  static const String getWarehouseReports =
      'method/elkhabaz_mobile.reports.stock.warehouse_balance';

  static const String getReports = 'method/elkhabaz_mobile.general.get_reports';

  static const String getStockLedgerReport =
      'method/elkhabaz_mobile.reports.stock.stock_ledger';

  static const String getItemPriceReport =
      'method/elkhabaz_mobile.reports.stock.item_price';

  static const String getGeneralLedgerReport =
      'method/elkhabaz_mobile.reports.accounts.general_ledger';

  static const String getUserProfileData =
      'method/elkhabaz_mobile.user_profile.user_profile';

  static const String updateUserProfileData =
      'method/elkhabaz_mobile.user_profile.update_user_profile';

  static const String getDashboardData =
      'method/elkhabaz_mobile.home_dashboard.get_home_data';

  static const String getFaqs = 'method/elkhabaz_mobile.general.get_faqs';

  static const String getTransactionList =
      'method/elkhabaz_mobile.general.get_activity_log';

  static const String getTotal =
      'method/elkhabaz_mobile.dashboard.get_dashboard_data';

  static const String generalListEndPoint =
      'method/elkhabaz_mobile.general.general_service';

  static const String generalItemListEndPoint =
      'method/elkhabaz_mobile.general.get_item_list';

  static const String getItemGroup =
      'method/elkhabaz_mobile.itemGroup.itemList';
  static const String getAccountReceivableReport =
      'method/elkhabaz_mobile.reports.accounts.accounts_receivable';

  static const String customerLocation = 'method/elkhabaz_mobile.customer_location.customer_location';
}
