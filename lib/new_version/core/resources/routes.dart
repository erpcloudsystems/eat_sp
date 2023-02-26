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

  static Map<String, WidgetBuilder> get routes {
    return {
      warehouseReportsScreen: (context) => const WarehouseReports(),
      modulesScreen: (context) => const ModulesPage(),
      reportsScreen: (context) => const ReportsPage(),
      noDataScreen: (context) => const NoDataScreen(),
    };
  }
}
