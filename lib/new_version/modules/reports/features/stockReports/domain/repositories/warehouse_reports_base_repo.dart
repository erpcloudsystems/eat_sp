import 'package:dartz/dartz.dart';

import '../../../../../../core/network/failure.dart';
import '../../data/models/warehouse_filters.dart';
import '../entities/warehouse_report_entity.dart';

abstract class WarehouseReportsBaseRepo {
  Future<Either<Failure, List<WarehouseReportEntity>>> getWarehouseReports(
      WarehouseFilters filters);
}

