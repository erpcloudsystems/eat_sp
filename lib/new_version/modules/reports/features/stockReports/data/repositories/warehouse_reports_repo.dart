import 'package:NextApp/new_version/core/network/exceptions.dart';
import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/core/network/network_info.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/data/datasources/warehouse_reports_data_source.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/entities/warehouse_report_entity.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/repositories/warehouse_reports_base_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/resources/strings_manager.dart';
import '../models/warehouse_filters.dart';

class WarehouseReportsRepo implements WarehouseReportsBaseRepo {
  final BaseNetworkInfo _networkInfo;
  final BaseWarehouseDataSource _warehouseDataSource;

  const WarehouseReportsRepo(this._networkInfo, this._warehouseDataSource);

  @override
  Future<Either<Failure, List<WarehouseReportEntity>>> getWarehouseReports(
      WarehouseFilters filters) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _warehouseDataSource.getWarehouseReports(filters);
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
          OfflineFailure(errorMessage: AppStrings.offlineFailureMessage));
    }
  }
}
