import 'package:NextApp/new_version/core/global/base_use_case.dart';
import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/entities/dashboard_entity.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/repositories/dashboard_base_repo.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/get_total_sales_invoice_filters.dart';

class GetDashboardUseCase
    extends BaseUseCase<DashboardEntity, TotalFilters> {
  final DashboardBaseRepo _repo;

  GetDashboardUseCase(this._repo);

  @override
  Future<Either<Failure, DashboardEntity>> call(
          TotalFilters parameters) async =>
      await _repo.getDashboard(parameters);
}
