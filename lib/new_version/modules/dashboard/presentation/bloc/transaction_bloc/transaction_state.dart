part of 'transaction_bloc.dart';

@immutable
class TransactionState extends Equatable {
  final RequestState getTaskState;
  final RequestState getLeaveState;
  final RequestState getEmployeeState;
  final RequestState getAttendanceState;
  final String getTaskMessage;
  final List<TapViewEntity> getTaskList;
  final List<TapViewEntity> getLeaveApplicationList;
  final List<TapViewEntity> getEmployeeCheckingList;
  final List<TapViewEntity> getAttendanceRequestList;

  const TransactionState({
    this.getTaskState = RequestState.loading,
    this.getLeaveState = RequestState.loading,
    this.getEmployeeState = RequestState.loading,
    this.getAttendanceState = RequestState.loading,
    this.getTaskMessage = '',
    this.getTaskList = const [],
    this.getLeaveApplicationList = const [],
    this.getEmployeeCheckingList = const [],
    this.getAttendanceRequestList = const [],
  });

  TransactionState copyWith({
    RequestState? getTaskState,
    RequestState? getLeaveState,
    RequestState? getEmployeeState,
    RequestState? getAttendanceState,
    String? getTaskMessage,
    List<TapViewEntity>? getTaskList,
    List<TapViewEntity>? getLeaveApplicationList,
    List<TapViewEntity>? getEmployeeCheckingList,
    List<TapViewEntity>? getAttendanceRequestList,
  }) =>
      TransactionState(
        getTaskState: getTaskState ?? this.getTaskState,
        getLeaveState: getLeaveState ?? this.getLeaveState,
        getEmployeeState: getEmployeeState ?? this.getEmployeeState,
        getAttendanceState: getAttendanceState ?? this.getAttendanceState,
        getTaskMessage: getTaskMessage ?? this.getTaskMessage,
        getTaskList: getTaskList ?? this.getTaskList,
        getLeaveApplicationList:
            getLeaveApplicationList ?? this.getLeaveApplicationList,
        getEmployeeCheckingList:
            getEmployeeCheckingList ?? this.getEmployeeCheckingList,
        getAttendanceRequestList:
            getAttendanceRequestList ?? this.getAttendanceRequestList,
      );

  @override
  List<Object?> get props => [
        getTaskState,
        getLeaveState,
        getEmployeeState,
        getAttendanceState,
        getTaskMessage,
        getTaskList,
        getLeaveApplicationList,
        getEmployeeCheckingList,
        getAttendanceRequestList,
      ];
}
