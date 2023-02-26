import '../../../../../../core/network/failure.dart';
import '../entities/task_entity.dart';
import 'package:dartz/dartz.dart';

abstract class BaseTaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks(int startNumber);
}
