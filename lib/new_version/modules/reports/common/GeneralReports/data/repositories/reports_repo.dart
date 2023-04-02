import 'package:NextApp/new_version/core/network/exceptions.dart';
import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/core/network/network_info.dart';
import 'package:NextApp/new_version/modules/reports/common/GeneralReports/data/datasources/reports_data_source.dart';
import 'package:NextApp/new_version/modules/reports/common/GeneralReports/domain/entities/report_entity.dart';
import 'package:NextApp/new_version/modules/reports/common/GeneralReports/domain/repositories/general_reports_base_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/resources/strings_manager.dart';

class ReportsRepo implements BaseReportsRepo {
  final BaseNetworkInfo _networkInfo;
  final BaseReportsDataSource _reportsDataSource;

  const ReportsRepo(this._networkInfo, this._reportsDataSource);

  @override
  Future<Either<Failure, List<ReportEntity>>> getAllReports(
      {required String moduleName}) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _reportsDataSource.getAllReports(moduleName);
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      } on DioError catch (e) {
        return Left(ServerFailure(errorMessage: e.message ?? StringsManager.unknownError));
      }
    } else {
      return const Left(
          OfflineFailure(errorMessage: StringsManager.offlineFailureMessage));
    }
  }
}
