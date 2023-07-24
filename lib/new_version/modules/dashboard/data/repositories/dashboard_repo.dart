import 'package:NextApp/new_version/core/network/exceptions.dart';
import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/modules/dashboard/data/data_sources/dashboard_data_source.dart';
import 'package:NextApp/new_version/modules/dashboard/data/models/get_total_sales_invoice_filters.dart';
import 'package:NextApp/new_version/modules/dashboard/data/models/transaction_filters.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/entities/counter_entity.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/entities/dashboard_entity.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/entities/sealse_invoice_entity.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/entities/tap_view_entity/task_entity.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/repositories/dashboard_base_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/resources/strings_manager.dart';

class DashboardRepo implements DashboardBaseRepo {
  final BaseNetworkInfo _networkInfo;
  final BaseDashboardDataDataSource _baseDashboardDataDataSource;

  DashboardRepo(
    this._networkInfo,
    this._baseDashboardDataDataSource,
  );

  @override
  Future<Either<Failure, DashboardEntity>> getDashboard(TotalFilters filterModel) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _baseDashboardDataDataSource.getDashboardData(filterModel);
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
        OfflineFailure(
          errorMessage: StringsManager.offlineFailureMessage,
        ),
      );
    }
  }


  @override
  Future<Either<Failure, CounterEntity>> getTotal(
      TotalFilters filterModel) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _baseDashboardDataDataSource
            .getTotalData(filterModel);
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
        OfflineFailure(
          errorMessage: StringsManager.offlineFailureMessage,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<TapViewEntity>>> getTaskList() async{
    if (await _networkInfo.isConnected) {
      try {
        final result = await _baseDashboardDataDataSource
            .getTaskList();
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
        OfflineFailure(
          errorMessage: StringsManager.offlineFailureMessage,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<TapViewEntity>>> getLeaveApplication()  async{
    if (await _networkInfo.isConnected) {
      try {
        final result = await _baseDashboardDataDataSource
            .getLeaveApplicationList();
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
        OfflineFailure(
          errorMessage: StringsManager.offlineFailureMessage,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<TapViewEntity>>> getEmployeeChecking() async{
    if (await _networkInfo.isConnected) {
      try {
        final result = await _baseDashboardDataDataSource
            .getEmployeeCheckingList();
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
        OfflineFailure(
          errorMessage: StringsManager.offlineFailureMessage,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<TapViewEntity>>> getAttendanceRequest() async{
    if (await _networkInfo.isConnected) {
      try {
        final result = await _baseDashboardDataDataSource
            .getAttendanceRequestList();
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
        OfflineFailure(
          errorMessage: StringsManager.offlineFailureMessage,
        ),
      );
    }
  }
}
