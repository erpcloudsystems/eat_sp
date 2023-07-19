import 'package:NextApp/new_version/core/global/base_use_case.dart';
import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/modules/new_item/data/models/item_filter.dart';
import 'package:NextApp/new_version/modules/new_item/domain/entities/item_entity.dart';
import 'package:NextApp/new_version/modules/new_item/domain/repositories/item_base_repo.dart';
import 'package:dartz/dartz.dart';

class GetItemsUseCase extends BaseUseCase<List<ItemEntity>, ItemsFilter> {
  final ItemBaseRepo _repo;

  GetItemsUseCase(this._repo);

  @override
  Future<Either<Failure, List<ItemEntity>>> call(
          ItemsFilter parameters) async =>
      await _repo.getItemList(parameters);
}
