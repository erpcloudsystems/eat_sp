import 'package:NextApp/new_version/core/global/base_use_case.dart';
import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/modules/dashboard/data/models/get_total_sales_invoice_filters.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/repositories/dashboard_base_repo.dart';
import 'package:dartz/dartz.dart';

import '../entities/counter_entity.dart';


class GetTotalUseCase
    extends BaseUseCase<CounterEntity, TotalFilters> {
  final DashboardBaseRepo _dashboardBaseRepo;

  GetTotalUseCase(this._dashboardBaseRepo);

  @override
  Future<Either<Failure, CounterEntity>> call(
      TotalFilters parameters) async =>
      await _dashboardBaseRepo.getTotal(parameters);
}
