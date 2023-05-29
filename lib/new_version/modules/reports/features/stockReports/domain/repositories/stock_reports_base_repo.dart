import 'package:dartz/dartz.dart';

import '../entities/item_price_entity.dart';
import '../entities/stock_ledger_entity.dart';
import '../entities/warehouse_report_entity.dart';
import '../../data/models/warehouse_filters.dart';
import '../../data/models/item_price_filters.dart';
import '../../data/models/stock_ledger_filter.dart';
import '../../../../../../core/network/failure.dart';

abstract class StockReportsBaseRepo {
  Future<Either<Failure, List<WarehouseReportEntity>>> getWarehouseReports(
      WarehouseFilters filters);

  Future<Either<Failure, List<StockLedgerEntity>>> getStockLedgerReports(
      StockLedgerFilters filters);

  Future<Either<Failure, List<ItemPriceEntity>>> getItemPriceReports(
      ItemPriceFilters filters);
}
