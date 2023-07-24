import 'package:NextApp/new_version/modules/dashboard/domain/entities/dashboard_entity.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/entities/sealse_invoice_entity.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/entities/tap_view_entity/task_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../data/models/get_total_sales_invoice_filters.dart';
import '../entities/counter_entity.dart';

abstract class DashboardBaseRepo {
  Future<Either<Failure, DashboardEntity>> getDashboard(TotalFilters filterModel);

  Future<Either<Failure, CounterEntity>> getTotal(
      TotalFilters filterModel);

  // Future<Either<Failure, CounterEntity>> getCustomerVisitCount(
  //   TotalFilters filterModel,
  // );

  Future<Either<Failure, List<TapViewEntity>>> getTaskList();

  Future<Either<Failure, List<TapViewEntity>>> getLeaveApplication();

  Future<Either<Failure, List<TapViewEntity>>> getEmployeeChecking();

  Future<Either<Failure, List<TapViewEntity>>> getAttendanceRequest();
}
