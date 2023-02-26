import 'package:NextApp/new_version/core/global/base_use_case.dart';
import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/modules/reports/common/GeneralReports/domain/entities/report_entity.dart';
import 'package:NextApp/new_version/modules/reports/common/GeneralReports/domain/repositories/general_reports_base_repo.dart';
import 'package:dartz/dartz.dart';

class GetAllReportsUseCase extends BaseUseCase<List<ReportEntity>, String> {
  final BaseReportsRepo _repo;
  GetAllReportsUseCase(this._repo);

  @override
  Future<Either<Failure, List<ReportEntity>>> call(String parameters) async =>
      _repo.getAllReports(moduleName: parameters);
}
