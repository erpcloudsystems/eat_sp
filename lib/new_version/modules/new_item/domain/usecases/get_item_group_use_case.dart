import 'package:NextApp/new_version/modules/new_item/domain/entities/item_group_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/global/base_use_case.dart';
import '../../../../core/network/failure.dart';
import '../../data/models/item_filter.dart';
import '../repositories/item_base_repo.dart';

class GetItemsGroupUseCase extends BaseUseCase<List<ItemGroupEntity>, ItemsFilter> {
  final ItemBaseRepo _repo;

  GetItemsGroupUseCase(this._repo);

  @override
  Future<Either<Failure, List<ItemGroupEntity>>> call(
          ItemsFilter parameters) async =>
      await _repo.getItemGroupList(parameters);
}
