import 'package:flutter/material.dart';

import '../../modules/reports/features/accounts_reports/presentation/accounts_receivable/screens/account_receivable_report_screen.dart';
import '../../modules/reports/features/accounts_reports/presentation/accounts_receivable/screens/accounts_receivable_filter.dart';
import '../utils/no_data_screen.dart';
import '../../modules/user_profile/presentation/pages/user_profile_screen.dart';
import '../../modules/user_profile/presentation/pages/edit_user_profile_screen.dart';
import '../../modules/reports/common/GeneralReports/presentation/pages/reports_page.dart';
import '../../modules/reports/features/accounts_reports/presentation/pages/general_ledger_report_screen.dart';
import '../../modules/reports/features/accounts_reports/presentation/widgets/filter_acount_screen.dart';
import '../../modules/reports/features/stockReports/presentation/pages/item_price_report.dart';
import '../../modules/reports/features/stockReports/presentation/pages/stock_ledger_report.dart';
import '../../modules/reports/features/stockReports/presentation/pages/warehouse_reports.dart';
import '../../modules/reports/features/stockReports/presentation/widgets/filter_screen.dart';

class Routes {
  static const String accountReportFilterScreen =
      '/account_reports_filter_screen';
  static const String generalLedgerReportScreen =
      '/general_ledger_reports_screen';
  static const String accountReceivableReportFilterScreen =
      '/account_receivable_report_filter_screen';
  static const String accountReceivableReportScreen =
      '/account_receivable_report_screen';

  static const String stockLedgerReportScreen = '/stock_ledger_reports_screen';
  static const String priceListReportScreen = '/price_list_reports_screen';
  static const String reportFilterScreen = '/reports_filter_screen';
  static const String editUserProfileScreen = '/edit_user_profile';
  static const String warehouseReportsScreen = '/warehouse';
  static const String userProfileScreen = '/user_profile';
  static const String modulesScreen = '/modules';
  static const String reportsScreen = '/reports';
  static const String noDataScreen = '/no_data';
  static const String pdfScreen = '/pdf_screen';

  static Map<String, WidgetBuilder> get routes {
    return {
      reportsScreen: (context) => const ReportsPage(),
      noDataScreen: (context) => const NoDataScreen(),
      reportFilterScreen: (context) => const FilterScreen(),
      userProfileScreen: (context) => const UserProfileScreen(),
      priceListReportScreen: (context) => const ItemPriceReport(),
      warehouseReportsScreen: (context) => const WarehouseReports(),
      stockLedgerReportScreen: (context) => const StockLedgerReport(),
      editUserProfileScreen: (context) => const EditUserProfileScreen(),
      accountReportFilterScreen: (context) => const FilterAccountScreen(),
      generalLedgerReportScreen: (context) => const GeneralLedgerReportScreen(),
      accountReceivableReportScreen: (_) =>
          const AccountReceivableReportScreen(),
      accountReceivableReportFilterScreen: (_) =>
          const AccountsReceivableFilterScreen(),
    };
  }
}
