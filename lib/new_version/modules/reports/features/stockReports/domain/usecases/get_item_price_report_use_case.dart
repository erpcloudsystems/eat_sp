import 'package:dartz/dartz.dart';

import '../entities/item_price_entity.dart';
import '../../data/models/item_price_filters.dart';
import '../../../../../../core/network/failure.dart';
import '../repositories/stock_reports_base_repo.dart';
import '../../../../../../core/global/base_use_case.dart';

class GetItemPriceUseCase
    extends BaseUseCase<List<ItemPriceEntity>, ItemPriceFilters> {
  final StockReportsBaseRepo _repo;

  GetItemPriceUseCase(this._repo);

  @override
  Future<Either<Failure, List<ItemPriceEntity>>> call(
          ItemPriceFilters parameters) async =>
      await _repo.getItemPriceReports(parameters);
}
