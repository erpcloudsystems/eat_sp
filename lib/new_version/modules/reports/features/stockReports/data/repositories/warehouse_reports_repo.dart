import 'package:dartz/dartz.dart';

import '../../../../../../core/network/exceptions.dart';
import '../../../../../../core/network/failure.dart';
import '../../../../../../core/network/network_info.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../../domain/entities/item_price_entity.dart';
import '../../domain/entities/stock_ledger_entity.dart';
import '../../domain/entities/warehouse_report_entity.dart';
import '../../domain/repositories/stock_reports_base_repo.dart';
import '../datasources/stock_reports_data_source.dart';
import '../models/item_price_filters.dart';
import '../models/stock_ledger_filter.dart';
import '../models/warehouse_filters.dart';

class StockReportsRepo implements StockReportsBaseRepo {
  final BaseNetworkInfo _networkInfo;
  final BaseStockReportDataSource _stockReportDataSource;

  const StockReportsRepo(this._networkInfo, this._stockReportDataSource);

  @override
  Future<Either<Failure, List<WarehouseReportEntity>>> getWarehouseReports(
      WarehouseFilters filters) async {
    if (await _networkInfo.isConnected) {
      try {
        final result =
            await _stockReportDataSource.getWarehouseReports(filters);
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
          OfflineFailure(errorMessage: StringsManager.offlineFailureMessage));
    }
  }

  @override
  Future<Either<Failure, List<StockLedgerEntity>>> getStockLedgerReports(
      StockLedgerFilters filters) async {
    if (await _networkInfo.isConnected) {
      try {
        final result =
            await _stockReportDataSource.getStockLedgerReports(filters);
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
          OfflineFailure(errorMessage: StringsManager.offlineFailureMessage));
    }
  }

  @override
  Future<Either<Failure, List<ItemPriceEntity>>> getItemPriceReports(
      ItemPriceFilters filters) async {
    if (await _networkInfo.isConnected) {
      try {
        final result =
            await _stockReportDataSource.getItemPriceReports(filters);
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
          OfflineFailure(errorMessage: StringsManager.offlineFailureMessage));
    }
  }
}
