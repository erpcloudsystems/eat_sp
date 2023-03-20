import 'package:NextApp/new_version/modules/reports/features/accounts_reports/presentation/pages/general_ledger_report_screen.dart';
import 'package:NextApp/new_version/modules/reports/features/accounts_reports/presentation/widgets/filter_acount_screen.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/presentation/pages/item_price_report.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/presentation/pages/stock_ledger_report.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/presentation/widgets/filter_screen.dart';

import '../../modules/reports/common/GeneralReports/presentation/pages/modules_page.dart';
import '../../modules/reports/features/stockReports/presentation/pages/warehouse_reports.dart';
import '../../modules/reports/common/GeneralReports/presentation/pages/reports_page.dart';
import 'package:flutter/material.dart';

import '../utils/no_data_screen.dart';

class Routes {
  static const String warehouseReportsScreen = '/warehouse';
  static const String modulesScreen = '/modules';
  static const String reportsScreen = '/reports';
  static const String noDataScreen = '/no_data';
  static const String reportFilterScreen = '/reports_filter_screen';
  static const String accountReportFilterScreen = '/account_reports_filter_screen';
  static const String stockLedgerReportScreen = '/stock_ledger_reports_screen';
  static const String priceListReportScreen = '/price_list_reports_screen';
  static const String generalLedgerReportScreen = '/general_ledger_reports_screen';

  static Map<String, WidgetBuilder> get routes {
    return {
      warehouseReportsScreen: (context) => const WarehouseReports(),
      modulesScreen: (context) => const ModulesPage(),
      reportsScreen: (context) => const ReportsPage(),
      noDataScreen: (context) => const NoDataScreen(),
      reportFilterScreen: (context) => const FilterScreen(),
      stockLedgerReportScreen: (context) => const StockLedgerReport(),
      priceListReportScreen: (context) => const ItemPriceReport(),
      generalLedgerReportScreen: (context) => const GeneralLedgerReportScreen(),
      accountReportFilterScreen: (context) => const FilterAccountScreen(),
    };
  }
}
