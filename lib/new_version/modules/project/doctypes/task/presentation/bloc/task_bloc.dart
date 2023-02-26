import 'dart:async';

import '../../../../../../core/utils/request_state.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/get_task_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTaskUseCase _getTaskUseCase;
  TaskBloc(
    this._getTaskUseCase,
  ) : super(TaskState()) {
    on<GetTaskEvent>(_getTask);
  }

  FutureOr<void> _getTask(GetTaskEvent event, Emitter<TaskState> emit) async {
    final result = await _getTaskUseCase(event.startKey);

    result.fold(
      (failure) => emit(state.copyWith(
        getTaskState: RequestState.error,
        getTaskMessage: failure.errorMessage,
      )),
      (tasks) => emit(state.copyWith(
        getTaskState: RequestState.success,
        getTaskData: tasks,
      )),
    );
  }
}
