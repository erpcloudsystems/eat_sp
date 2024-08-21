import 'package:dartz/dartz.dart';

import '../../../../../../core/global/base_use_case.dart';
import '../../../../../../core/network/failure.dart';
import '../entities/report_entity.dart';
import '../repositories/general_reports_base_repo.dart';

class GetAllReportsUseCase extends BaseUseCase<List<ReportEntity>, String> {
  final BaseReportsRepo _repo;
  GetAllReportsUseCase(this._repo);

  @override
  Future<Either<Failure, List<ReportEntity>>> call(String parameters) async =>
      _repo.getAllReports(moduleName: parameters);
}
