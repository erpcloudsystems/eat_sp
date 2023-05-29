import 'package:dartz/dartz.dart';

import '../entities/update_user_entity.dart';
import '../entities/user_entity.dart';
import '../../../../core/network/failure.dart';

abstract class BaseUserRepository {
  Future<Either<Failure, UserEntity>> getUserProfileData(String userName);
  Future<Either<Failure, UserEntity>> updateUserProfileData(UpdateUserEntity newUserData);
}
