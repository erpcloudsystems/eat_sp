import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/entities/warehouse_report_entity.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/warehouse_filters.dart';

abstract class WarehouseReportsBaseRepo {
  Future<Either<Failure, List<WarehouseReportEntity>>> getWarehouseReports(
      WarehouseFilters filters);
}

