import 'dart:async';

import 'package:NextApp/new_version/core/global/base_use_case.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/entities/tap_view_entity/task_entity.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/use_cases/tap_view_use_case/get_attendance_request_use_case.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/use_cases/tap_view_use_case/get_employeeChecking.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/use_cases/tap_view_use_case/get_task_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/utils/request_state.dart';
import '../../../domain/use_cases/tap_view_use_case/get_leave_app_use_case.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTaskUseCase _getTaskUseCase;
  final GetLeaveApplicationCase _getLeaveApplicationCase;
  final GetEmployeeCheckingUseCase _getEmployeeCheckingUseCase;
  final GetAttendanceRequestUseCase _getAttendanceRequestUseCase;

  TransactionBloc(
    this._getTaskUseCase,
    this._getLeaveApplicationCase,
    this._getEmployeeCheckingUseCase,
    this._getAttendanceRequestUseCase,
  ) : super(const TransactionState()) {
    on<GetTaskEvent>(_getTaskData, transformer: droppable());
    on<GetLeaveApplicationEvent>(_getLeaveListApplication,
        transformer: droppable());
    on<GetEmployeeCheckingEvent>(_getEmployeeCheckingData,
        transformer: droppable());
    on<GetAttendanceRequestEvent>(_getAttendanceRequestData,
        transformer: droppable());
  }

  FutureOr<void> _getTaskData(
      GetTaskEvent event, Emitter<TransactionState> emit) async {
    if (state.getTaskState == RequestState.loading) {
      final result = await _getTaskUseCase(const NoParameters());

      result.fold(
        (failure) => emit(state.copyWith(
          getTaskState: RequestState.error,
          getTaskMessage: failure.errorMessage,
        )),
        (getTransaction) => emit(
          state.copyWith(
            getTaskState: RequestState.success,
            getTaskList: getTransaction,
          ),
        ),
      );
    }
  }

  FutureOr<void> _getLeaveListApplication(
      GetLeaveApplicationEvent event, Emitter<TransactionState> emit) async {
    if (state.getLeaveState == RequestState.loading) {
      final result = await _getLeaveApplicationCase(const NoParameters());

      result.fold(
        (failure) => emit(state.copyWith(
          getLeaveState: RequestState.error,
          getTaskMessage: failure.errorMessage,
        )),
        (getLeaveApp) => emit(
          state.copyWith(
            getLeaveState: RequestState.success,
            getLeaveApplicationList: getLeaveApp,
          ),
        ),
      );
    }
  }

  FutureOr<void> _getEmployeeCheckingData(
      GetEmployeeCheckingEvent event, Emitter<TransactionState> emit) async {
    if (state.getEmployeeState == RequestState.loading) {
      final result = await _getEmployeeCheckingUseCase(const NoParameters());

      result.fold(
        (failure) => emit(state.copyWith(
          getEmployeeState: RequestState.error,
          getTaskMessage: failure.errorMessage,
        )),
        (getLeaveApp) => emit(
          state.copyWith(
            getEmployeeState: RequestState.success,
            getEmployeeCheckingList: getLeaveApp,
          ),
        ),
      );
    }
  }

  FutureOr<void> _getAttendanceRequestData(
      GetAttendanceRequestEvent event, Emitter<TransactionState> emit) async {
    if (state.getAttendanceState == RequestState.loading) {
      final result = await _getAttendanceRequestUseCase(const NoParameters());

      result.fold(
            (failure) => emit(state.copyWith(
              getAttendanceState: RequestState.error,
          getTaskMessage: failure.errorMessage,
        )),
            (getList) => emit(
          state.copyWith(
            getAttendanceState: RequestState.success,
            getAttendanceRequestList: getList,
          ),
        ),
      );
    }
  }
}
