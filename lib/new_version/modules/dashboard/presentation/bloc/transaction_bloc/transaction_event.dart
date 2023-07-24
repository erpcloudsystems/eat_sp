part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent extends Equatable{
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class GetTaskEvent extends TransactionEvent {
  const GetTaskEvent();

  @override
  List<Object> get props => [];
}

class GetLeaveApplicationEvent extends TransactionEvent {
  const GetLeaveApplicationEvent();

  @override
  List<Object> get props => [];
}

class GetEmployeeCheckingEvent extends TransactionEvent {
  const GetEmployeeCheckingEvent();

  @override
  List<Object> get props => [];
}

class GetAttendanceRequestEvent extends TransactionEvent {
  const GetAttendanceRequestEvent();

  @override
  List<Object> get props => [];
}


