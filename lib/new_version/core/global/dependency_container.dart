import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../modules/project/doctypes/task/data/datasources/task_data_source.dart';
import '../../modules/project/doctypes/task/data/repositories/task_repository.dart';
import '../../modules/project/doctypes/task/domain/repositories/task_repositories.dart';
import '../../modules/project/doctypes/task/domain/usecases/get_task_use_case.dart';
import '../../modules/project/doctypes/task/presentation/bloc/task_bloc.dart';
import '../../modules/reports/common/GeneralReports/data/datasources/reports_data_source.dart';
import '../../modules/reports/common/GeneralReports/data/repositories/reports_repo.dart';
import '../../modules/reports/common/GeneralReports/domain/repositories/general_reports_base_repo.dart';
import '../../modules/reports/common/GeneralReports/domain/usecases/get_all_reports_use_case.dart';
import '../../modules/reports/common/GeneralReports/presentation/bloc/generalreports_bloc.dart';
import '../../modules/reports/features/stockReports/data/datasources/warehouse_reports_data_source.dart';
import '../../modules/reports/features/stockReports/data/repositories/warehouse_reports_repo.dart';
import '../../modules/reports/features/stockReports/domain/repositories/warehouse_reports_base_repo.dart';
import '../../modules/reports/features/stockReports/domain/usecases/get_warehouse_reports_use_case.dart';
import '../../modules/reports/features/stockReports/presentation/bloc/stockreports_bloc.dart';
import '../network/dio_helper.dart';
import '../network/network_info.dart';



final sl = GetIt.instance;

Future<void> init() async {
  /// Bloc
  // Task Bloc
  sl.registerFactory(() => TaskBloc(sl()));

  // Reports Bloc
  sl.registerFactory(() => GeneralReportsBloc(sl()));
  sl.registerFactory(() => StockReportsBloc(sl()));

  /// Use cases
  // Task use case
  sl.registerLazySingleton(() => GetTaskUseCase(sl()));

  // Reports
  sl.registerLazySingleton(() => GetAllReportsUseCase(sl()));
  sl.registerLazySingleton(() => GetWarehouseReportsUseCase(sl()));

  /// Repositories
  // Task Repository
  sl.registerLazySingleton<BaseTaskRepository>(
      () => TaskRepository(sl(), sl()));

  // Reports
  sl.registerLazySingleton<BaseReportsRepo>(() => ReportsRepo(sl(), sl()));
  sl.registerLazySingleton<WarehouseReportsBaseRepo>(
      () => WarehouseReportsRepo(sl(), sl()));

  /// DataSources
  // Task data sources
  sl.registerLazySingleton<BaseTaskDataSource>(() => TaskDataSourceByDio(sl()));

  // Reports
  sl.registerLazySingleton<BaseReportsDataSource>(
      () => ReportsDataSourceByDio(sl()));
  sl.registerLazySingleton<BaseWarehouseDataSource>(
      () => WarehouseDataSourceByDio(sl()));

  /// External
  sl.registerLazySingleton<BaseDioHelper>(() => DioHelper());
  sl.registerLazySingleton<BaseNetworkInfo>(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
