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
      'method/eat_mobile.general.general_service?start=$startKey&doctype=$docType&page_length=2';

  static const String getWarehouseReports =
      'method/eat_mobile.reports.stock.warehouse_balance';

  static const String getReports = 'method/eat_mobile.general.get_reports';

  static const String getStockLedgerReport =
      'method/eat_mobile.reports.stock.stock_ledger';

  static const String getItemPriceReport =
      'method/eat_mobile.reports.stock.item_price';

  static const String getGeneralLedgerReport =
      'method/eat_mobile.reports.accounts.general_ledger';

  static const String getUserProfileData =
      'method/eat_mobile.user_profile.user_profile';

  static const String updateUserProfileData =
      'method/eat_mobile.user_profile.update_user_profile';

  static const String getDashboardData =
      'method/eat_mobile.home_dashboard.get_home_data';

  static const String getFaqs = 'method/eat_mobile.general.get_faqs';

  static const String getTransactionList =
      'method/eat_mobile.general.get_activity_log';

  static const String getTotal =
      'method/eat_mobile.dashboard.get_dashboard_data';

  static const String generalListEndPoint =
      'method/eat_mobile.general.general_service';

  static const String generalItemListEndPoint =
      'method/eat_mobile.general.get_item_list';

  static const String getItemGroup = 'method/eat_mobile.itemGroup.itemList';
}
