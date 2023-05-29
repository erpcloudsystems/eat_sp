import 'package:dartz/dartz.dart';

import '../entities/user_entity.dart';
import '../entities/update_user_entity.dart';
import '../repositories/base_user_repo.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/global/base_use_case.dart';

class UpdateUserProfileDataUseCase extends BaseUseCase<UserEntity, UpdateUserEntity> {
  final BaseUserRepository _repository;
  UpdateUserProfileDataUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserEntity parameters) async =>
      await _repository.updateUserProfileData(parameters);
}
