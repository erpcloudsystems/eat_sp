import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_helper.dart';
import '../network/network_info.dart';
import '../../modules/user_profile/domain/repositories/base_user_repo.dart';
import '../../modules/user_profile/data/repositories/user_profile_repo.dart';
import '../../modules/user_profile/presentation/bloc/user_profile_bloc.dart';
import '../../modules/user_profile/data/datasources/user_profile_data_source.dart';
import '../../modules/user_profile/domain/usecases/get_user_profile_data_use_case.dart';
import '../../modules/user_profile/domain/usecases/update_user_profile_data_use_case.dart';
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

  /// External
  sl.registerLazySingleton<BaseDioHelper>(() => DioHelper());
  sl.registerLazySingleton<BaseNetworkInfo>(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
