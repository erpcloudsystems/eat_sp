import 'package:NextApp/new_version/modules/new_item/data/datasources/items_data_source.dart';
import 'package:NextApp/new_version/modules/new_item/data/repositories/items_repo.dart';
import 'package:NextApp/new_version/modules/new_item/domain/repositories/item_base_repo.dart';
import 'package:NextApp/new_version/modules/new_item/domain/usecases/get_item_group_use_case.dart';
import 'package:NextApp/new_version/modules/new_item/domain/usecases/get_items_use_case.dart';
import 'package:NextApp/new_version/modules/new_item/presentation/bloc/new_item_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../modules/dashboard/data/data_sources/dashboard_data_source.dart';
import '../../modules/dashboard/data/repositories/dashboard_repo.dart';
import '../../modules/dashboard/domain/repositories/dashboard_base_repo.dart';
import '../../modules/dashboard/domain/use_cases/get_dashboard_data_use_case.dart';
import '../../modules/dashboard/domain/use_cases/get_total.dart';
import '../../modules/dashboard/domain/use_cases/tap_view_use_case/get_attendance_request_use_case.dart';
import '../../modules/dashboard/domain/use_cases/tap_view_use_case/get_employeeChecking.dart';
import '../../modules/dashboard/domain/use_cases/tap_view_use_case/get_leave_app_use_case.dart';
import '../../modules/dashboard/domain/use_cases/tap_view_use_case/get_task_use_case.dart';
import '../../modules/dashboard/presentation/bloc/dasboard_bloc.dart';
import '../../modules/dashboard/presentation/bloc/total_bloc/total_bloc.dart';
import '../../modules/dashboard/presentation/bloc/transaction_bloc/transaction_bloc.dart';
import '../../modules/faq/data/datasources/faq_data_sourcs.dart';
import '../../modules/faq/data/repositories/faq_implementaion_repo.dart';
import '../../modules/faq/domain/repositories/faq_base_repo.dart';
import '../../modules/faq/domain/usecases/get_faqs_use_case.dart';
import '../../modules/faq/presentation/bloc/faq_bloc.dart';
import '../../modules/reports/common/GeneralReports/data/datasources/reports_data_source.dart';
import '../../modules/reports/common/GeneralReports/data/repositories/reports_repo.dart';
import '../../modules/reports/common/GeneralReports/domain/repositories/general_reports_base_repo.dart';
import '../../modules/reports/common/GeneralReports/domain/usecases/get_all_reports_use_case.dart';
import '../../modules/reports/common/GeneralReports/presentation/bloc/generalreports_bloc.dart';
import '../../modules/reports/features/accounts_reports/data/data_sources/account_report_data_source.dart';
import '../../modules/reports/features/accounts_reports/data/repositories/account_report_repo.dart';
import '../../modules/reports/features/accounts_reports/domain/repositories/account_report_base_repo.dart';
import '../../modules/reports/features/accounts_reports/domain/use_cases/get_general_ledger_report_use_case.dart';
import '../../modules/reports/features/accounts_reports/presentation/bloc/general_ledger_bloc/general_ledger_bloc.dart';
import '../../modules/reports/features/stockReports/data/datasources/stock_reports_data_source.dart';
import '../../modules/reports/features/stockReports/data/repositories/warehouse_reports_repo.dart';
import '../../modules/reports/features/stockReports/domain/repositories/stock_reports_base_repo.dart';
import '../../modules/reports/features/stockReports/domain/usecases/get_item_price_report_use_case.dart';
import '../../modules/reports/features/stockReports/domain/usecases/get_stock_ledger_report_use_case.dart';
import '../../modules/reports/features/stockReports/domain/usecases/get_warehouse_reports_use_case.dart';
import '../../modules/reports/features/stockReports/presentation/bloc/item_price_bloc/item_price_bloc.dart';
import '../../modules/reports/features/stockReports/presentation/bloc/stock_ledger_bloc/stock_ledger_bloc.dart';
import '../../modules/reports/features/stockReports/presentation/bloc/stock_warehouse_report/stockreports_bloc.dart';
import '../../modules/user_profile/data/datasources/user_profile_data_source.dart';
import '../../modules/user_profile/data/repositories/user_profile_repo.dart';
import '../../modules/user_profile/domain/repositories/base_user_repo.dart';
import '../../modules/user_profile/domain/usecases/get_user_profile_data_use_case.dart';
import '../../modules/user_profile/domain/usecases/update_user_profile_data_use_case.dart';
import '../../modules/user_profile/presentation/bloc/user_profile_bloc.dart';
import '../network/dio_helper.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Bloc

  // Reports
  sl.registerFactory(() => GeneralReportsBloc(sl()));
  sl.registerFactory(() => StockReportsBloc(sl()));
  sl.registerFactory(() => StockLedgerBloc(sl()));
  sl.registerFactory(() => ItemPriceBloc(sl()));
  sl.registerFactory(() => GeneralLedgerBloc(sl()));

  // User Profile
  sl.registerFactory(() => UserProfileBloc(sl(), sl()));

  // Faqs
  sl.registerFactory(() => FaqBloc(sl()));

  // Dashboard bloc
  sl.registerFactory(() => DashboardBloc(sl()));
  sl.registerFactory(() => TotalBloc(sl()));
  sl.registerFactory(() => TransactionBloc(sl(), sl(), sl(), sl()));

  ///Item Bloc
  sl.registerFactory(() => NewItemBloc(sl(),sl()));

  /// Use cases

  // Reports
  sl.registerLazySingleton(() => GetAllReportsUseCase(sl()));
  sl.registerLazySingleton(() => GetWarehouseReportsUseCase(sl()));
  sl.registerLazySingleton(() => GetStockLedgerUseCase(sl()));
  sl.registerLazySingleton(() => GetItemPriceUseCase(sl()));
  sl.registerLazySingleton(() => GetGeneralLedgerUseCase(sl()));

  // User Profile
  sl.registerLazySingleton(() => GetUserProfileDataUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserProfileDataUseCase(sl()));

  // Faqs
  sl.registerLazySingleton(() => GetFaqsUseCase(sl()));

  // Dashboard use case
  sl.registerLazySingleton(() => GetDashboardUseCase(sl()));
  sl.registerLazySingleton(() => GetTotalUseCase(sl()));
  sl.registerLazySingleton(() => GetTaskUseCase(sl()));
  sl.registerLazySingleton(() => GetLeaveApplicationCase(sl()));
  sl.registerLazySingleton(() => GetEmployeeCheckingUseCase(sl()));
  sl.registerLazySingleton(() => GetAttendanceRequestUseCase(sl()));

// New Item use case
  sl.registerLazySingleton(() => GetItemsUseCase(sl()));
  sl.registerLazySingleton(() => GetItemsGroupUseCase(sl()));

  /// Repositories

  // Reports
  sl.registerLazySingleton<BaseReportsRepo>(() => ReportsRepo(sl(), sl()));
  sl.registerLazySingleton<StockReportsBaseRepo>(
      () => StockReportsRepo(sl(), sl()));
  sl.registerLazySingleton<AccountReportBaseRepo>(
      () => AccountReportsRepo(sl(), sl()));

  // User Profile
  sl.registerLazySingleton<BaseUserRepository>(
      () => UserProfileRepoImplementation(sl(), sl()));

  // Faqs
  sl.registerLazySingleton<FaqBaseRepo>(
      () => FaqImplementationRepo(sl(), sl()));
  // dashboard
  sl.registerLazySingleton<DashboardBaseRepo>(() => DashboardRepo(sl(), sl()));

  // New item
  sl.registerLazySingleton<ItemBaseRepo>(() => ItemsRepo(sl(), sl()));

  /// DataSources

  // Reports
  sl.registerLazySingleton<BaseReportsDataSource>(
      () => ReportsDataSourceByDio(sl()));
  sl.registerLazySingleton<BaseStockReportDataSource>(
      () => StockReportDataSourceByDio(sl()));
  sl.registerLazySingleton<BaseAccountReportDataSource>(
      () => AccountReportDataSourceByDio(sl()));

  // User Profile
  sl.registerLazySingleton<BaseUserProfileDataSource>(
      () => UserDataSourceByDio(sl()));

  // Faqs
  sl.registerLazySingleton<FaqBaseDataSource>(() => FaqDataSourceByDio(sl()));

  // Dashboard
  sl.registerLazySingleton<BaseDashboardDataDataSource>(
      () => DashboardDataSourceByDio(sl()));

  // Dashboard
  sl.registerLazySingleton<BaseItemsDataSource>(
      () => ItemDataSourceByDio(sl()));

  /// External
  sl.registerLazySingleton<BaseDioHelper>(() => DioHelper());
  sl.registerLazySingleton<BaseNetworkInfo>(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
