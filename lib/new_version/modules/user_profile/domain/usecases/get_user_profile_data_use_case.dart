import 'package:dartz/dartz.dart';

import 'package:NextApp/new_version/core/network/failure.dart';

import '../../../../core/global/base_use_case.dart';
import '../entities/user_entity.dart';
import '../repositories/base_user_repo.dart';

class GetUserProfileDataUseCase extends BaseUseCase<UserEntity, String> {
  final BaseUserRepository _repo;

  GetUserProfileDataUseCase(this._repo);

  @override
  Future<Either<Failure, UserEntity>> call(String parameters) async =>
      _repo.getUserProfileData(parameters);
}
