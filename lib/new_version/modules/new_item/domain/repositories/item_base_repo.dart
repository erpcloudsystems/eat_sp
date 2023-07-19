import 'package:NextApp/new_version/modules/new_item/domain/entities/item_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../data/models/item_filter.dart';
import '../entities/item_group_entity.dart';

abstract class ItemBaseRepo {
  Future<Either<Failure, List<ItemEntity>>> getItemList(ItemsFilter filters);

  Future<Either<Failure, List<ItemGroupEntity>>> getItemGroupList(ItemsFilter filters);
}
