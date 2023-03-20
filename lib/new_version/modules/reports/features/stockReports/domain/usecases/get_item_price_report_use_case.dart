import 'package:NextApp/new_version/modules/reports/features/stockReports/data/models/item_price_filters.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/entities/item_price_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../../../core/global/base_use_case.dart';
import '../../../../../../core/network/failure.dart';
import '../repositories/stock_reports_base_repo.dart';

class GetItemPriceUseCase
    extends BaseUseCase<List<ItemPriceEntity>, ItemPriceFilters> {
  final StockReportsBaseRepo _repo;

  GetItemPriceUseCase(this._repo);

  @override
  Future<Either<Failure, List<ItemPriceEntity>>> call(
      ItemPriceFilters parameters) async =>
      await _repo.getItemPriceReports(parameters);
}