import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/modules/reports/common/GeneralReports/domain/entities/report_entity.dart';
import 'package:dartz/dartz.dart';

abstract class BaseReportsRepo {
  Future<Either<Failure, List<ReportEntity>>> getAllReports(
      {required String moduleName});
}
