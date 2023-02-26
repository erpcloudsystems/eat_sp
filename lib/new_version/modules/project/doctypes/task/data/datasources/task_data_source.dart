import 'package:dio/dio.dart';

import '../../../../../../core/network/api_constance.dart';
import '../../../../../../core/network/dio_helper.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../models/task_model.dart';

abstract class BaseTaskDataSource {
  Future<List<TaskModel>> getTask(int startKey);
}

class TaskDataSourceByDio implements BaseTaskDataSource {
  final BaseDioHelper _dio;
  const TaskDataSourceByDio(this._dio);

  @override
  Future<List<TaskModel>> getTask(int startKey) async {
    final response = await _dio.get(
        endPoint: ApiConstance.generalGet(
      docType: DocTypesName.task,
      startKey: startKey,
    )) as Response;

    final tasks = List.from(response.data['message'])
        .map((e) => TaskModel.fromJson(e))
        .toList();

    return tasks;
  }
}
