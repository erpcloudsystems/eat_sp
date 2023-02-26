import 'package:NextApp/new_version/core/global/base_use_case.dart';
import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/entities/warehouse_report_entity.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/repositories/warehouse_reports_base_repo.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/warehouse_filters.dart';

class GetWarehouseReportsUseCase
    extends BaseUseCase<List<WarehouseReportEntity>, WarehouseFilters> {
  final WarehouseReportsBaseRepo _repo;
  GetWarehouseReportsUseCase(this._repo);

  @override
  Future<Either<Failure, List<WarehouseReportEntity>>> call(
          WarehouseFilters parameters) async =>
      await _repo.getWarehouseReports(parameters);
}
