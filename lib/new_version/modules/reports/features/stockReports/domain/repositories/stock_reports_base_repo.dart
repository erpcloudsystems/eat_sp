import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/data/models/item_price_filters.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/entities/item_price_entity.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/entities/stock_ledger_entity.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/entities/warehouse_report_entity.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/stock_ledger_filter.dart';
import '../../data/models/warehouse_filters.dart';

abstract class StockReportsBaseRepo {
  Future<Either<Failure, List<WarehouseReportEntity>>> getWarehouseReports(
      WarehouseFilters filters);

  Future<Either<Failure, List<StockLedgerEntity>>> getStockLedgerReports(
      StockLedgerFilters filters);

  Future<Either<Failure, List<ItemPriceEntity>>> getItemPriceReports(
      ItemPriceFilters filters);
}

