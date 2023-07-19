import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/modules/new_item/data/datasources/items_data_source.dart';

import 'package:NextApp/new_version/modules/new_item/data/models/item_filter.dart';

import 'package:NextApp/new_version/modules/new_item/domain/entities/item_entity.dart';
import 'package:NextApp/new_version/modules/new_item/domain/entities/item_group_entity.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/network/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../domain/repositories/item_base_repo.dart';

class ItemsRepo implements ItemBaseRepo {
  final BaseNetworkInfo _networkInfo;
  final BaseItemsDataSource _baseItemsDataSource;

  ItemsRepo(
    this._networkInfo,
    this._baseItemsDataSource,
  );
  @override
  Future<Either<Failure, List<ItemEntity>>> getItemList(
      ItemsFilter filters) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _baseItemsDataSource.getItemList(filters);
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
        OfflineFailure(
          errorMessage: StringsManager.offlineFailureMessage,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ItemGroupEntity>>> getItemGroupList(
      ItemsFilter filters) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _baseItemsDataSource.getItemGroupList(filters);
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
        OfflineFailure(
          errorMessage: StringsManager.offlineFailureMessage,
        ),
      );
    }
  }
}
