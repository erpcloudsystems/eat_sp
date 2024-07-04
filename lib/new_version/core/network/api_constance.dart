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
      'method/ecs_eat.eat_sp.general.general_service?start=$startKey&doctype=$docType&page_length=2';

  static const String getWarehouseReports =
      'method/ecs_eat.eat_sp.reports.stock.warehouse_balance';

  static const String getReports = 'method/ecs_eat.eat_sp.general.get_reports';

  static const String getStockLedgerReport =
      'method/ecs_eat.eat_sp.reports.stock.stock_ledger';

  static const String getItemPriceReport =
      'method/ecs_eat.eat_sp.reports.stock.item_price';

  static const String getGeneralLedgerReport =
      'method/ecs_eat.eat_sp.reports.accounts.general_ledger';

  static const String getUserProfileData =
      'method/ecs_eat.eat_sp.user_profile.user_profile';

  static const String updateUserProfileData =
      'method/ecs_eat.eat_sp.user_profile.update_user_profile';

  static const String getDashboardData =
      'method/ecs_eat.eat_sp.home_dashboard.get_home_data';

  static const String getFaqs = 'method/ecs_eat.eat_sp.general.get_faqs';

  static const String getTransactionList =
      'method/ecs_eat.eat_sp.general.get_activity_log';

  static const String getTotal =
      'method/ecs_eat.eat_sp.dashboard.get_dashboard_data';

  static const String generalListEndPoint =
      'method/ecs_eat.eat_sp.general.general_service';

  static const String generalItemListEndPoint =
      'method/ecs_eat.eat_sp.general.get_item_list';

  static const String getItemGroup = 'method/ecs_eat.eat_sp.itemGroup.itemList';
}
