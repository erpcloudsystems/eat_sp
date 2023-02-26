import '../../../../../../core/global/base_use_case.dart';
import '../../../../../../core/network/failure.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repositories.dart';
import 'package:dartz/dartz.dart';

class GetTaskUseCase extends BaseUseCase<List<TaskEntity>, int> {
  final BaseTaskRepository _repository;
  GetTaskUseCase(this._repository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call(int parameters) async =>
      await _repository.getTasks(parameters);
}
