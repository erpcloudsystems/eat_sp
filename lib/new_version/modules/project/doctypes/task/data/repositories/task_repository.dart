import '../../../../../../core/network/exceptions.dart';
import '../../../../../../core/network/network_info.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../datasources/task_data_source.dart';
import '../../domain/entities/task_entity.dart';
import '../../../../../../core/network/failure.dart';
import '../../domain/repositories/task_repositories.dart';
import 'package:dartz/dartz.dart';

class TaskRepository implements BaseTaskRepository {
  final BaseNetworkInfo _networkInfo;
  final BaseTaskDataSource _taskDataSource;

  const TaskRepository(this._networkInfo, this._taskDataSource);

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks(int startNumber) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _taskDataSource.getTask(startNumber);
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
        OfflineFailure(errorMessage: AppStrings.offlineFailureMessage),
      );
    }
  }
}
