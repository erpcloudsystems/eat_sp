import 'package:dartz/dartz.dart';

import '../../../../../../core/global/base_use_case.dart';
import '../../../../../../core/network/failure.dart';
import '../../data/models/stock_ledger_filter.dart';
import '../entities/stock_ledger_entity.dart';
import '../repositories/stock_reports_base_repo.dart';

class GetStockLedgerUseCase
    extends BaseUseCase<List<StockLedgerEntity>, StockLedgerFilters> {
  final StockReportsBaseRepo _repo;

  GetStockLedgerUseCase(this._repo);

  @override
  Future<Either<Failure, List<StockLedgerEntity>>> call(
          StockLedgerFilters parameters) async =>
      await _repo.getStockLedgerReports(parameters);
}
