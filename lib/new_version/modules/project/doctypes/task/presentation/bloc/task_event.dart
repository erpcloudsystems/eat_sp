part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class GetTaskEvent extends TaskEvent {
  final int startKey;
  const GetTaskEvent({required this.startKey});
}
