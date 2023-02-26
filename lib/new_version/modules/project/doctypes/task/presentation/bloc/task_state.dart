part of 'task_bloc.dart';

class TaskState extends Equatable {
  final RequestState getTaskState;
  final String getTaskMessage;
  final List<TaskEntity> getTaskData;

  const TaskState({
    this.getTaskState = RequestState.loading,
    this.getTaskMessage = '',
    this.getTaskData = const [],
  });

  TaskState copyWith({
    RequestState? getTaskState,
    String? getTaskMessage,
    List<TaskEntity>? getTaskData,
  }) =>
      TaskState(
        getTaskState: getTaskState ?? this.getTaskState,
        getTaskMessage: getTaskMessage ?? this.getTaskMessage,
        getTaskData: getTaskData ?? this.getTaskData,
      );

  @override
  List<Object> get props => [
        getTaskState,
        getTaskMessage,
        getTaskData,
      ];
}
