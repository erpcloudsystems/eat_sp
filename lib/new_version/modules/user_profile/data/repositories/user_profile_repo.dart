import 'package:dartz/dartz.dart';

import '../models/update_user_model.dart';
import '../../../../core/network/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/user_profile_data_source.dart';
import '../../domain/entities/update_user_entity.dart';
import '../../domain/repositories/base_user_repo.dart';
import '../../../../core/resources/strings_manager.dart';

class UserProfileRepoImplementation implements BaseUserRepository {
  final BaseUserProfileDataSource _dataSource;
  final BaseNetworkInfo _networkInfo;

  const UserProfileRepoImplementation(this._dataSource, this._networkInfo);

  @override
  Future<Either<Failure, UserEntity>> getUserProfileData(
      String username) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _dataSource.getUserProfileDataSource(username);
        return Right(response);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
          OfflineFailure(errorMessage: StringsManager.offlineFailureMessage));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfileData(
      UpdateUserEntity newUser) async {
    if (await _networkInfo.isConnected) {
      try {
        final newUserModel = UpdateUserModel(
         firstName: newUser.firstName,
         lastName: newUser.lastName,
         birthDate: newUser.birthDate,
         gender: newUser.gender,
         filename: newUser.filename,
         imageContent: newUser.imageContent
        );

        final newUserData =
            await _dataSource.updateUserProfileDataSource(newUserModel);
        return Right(newUserData);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
          OfflineFailure(errorMessage: StringsManager.offlineFailureMessage));
    }
  }
}
