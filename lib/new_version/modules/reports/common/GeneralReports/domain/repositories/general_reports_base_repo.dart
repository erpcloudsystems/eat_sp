import 'package:dartz/dartz.dart';

import '../../../../../../core/network/failure.dart';
import '../entities/report_entity.dart';

abstract class BaseReportsRepo {
  Future<Either<Failure, List<ReportEntity>>> getAllReports(
      {required String moduleName});
}
