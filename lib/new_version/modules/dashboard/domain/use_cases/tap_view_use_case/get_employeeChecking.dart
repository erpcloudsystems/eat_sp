import 'package:NextApp/new_version/core/global/base_use_case.dart';
import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/entities/tap_view_entity/task_entity.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/repositories/dashboard_base_repo.dart';
import 'package:dartz/dartz.dart';


class GetEmployeeCheckingUseCase
    extends BaseUseCase<List<TapViewEntity>, NoParameters> {
  final DashboardBaseRepo _dashboardBaseRepo;

  GetEmployeeCheckingUseCase(this._dashboardBaseRepo);

  @override
  Future<Either<Failure, List<TapViewEntity>>> call(NoParameters parameters) async =>
      await _dashboardBaseRepo.getEmployeeChecking();
}
