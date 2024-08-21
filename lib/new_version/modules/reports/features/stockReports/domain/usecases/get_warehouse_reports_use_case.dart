import 'package:dartz/dartz.dart';

import '../../../../../../core/global/base_use_case.dart';
import '../../../../../../core/network/failure.dart';
import '../../data/models/warehouse_filters.dart';
import '../entities/warehouse_report_entity.dart';
import '../repositories/stock_reports_base_repo.dart';

class GetWarehouseReportsUseCase
    extends BaseUseCase<List<WarehouseReportEntity>, WarehouseFilters> {
  final StockReportsBaseRepo _repo;
  GetWarehouseReportsUseCase(this._repo);

  @override
  Future<Either<Failure, List<WarehouseReportEntity>>> call(
          WarehouseFilters parameters) async =>
      await _repo.getWarehouseReports(parameters);
}
