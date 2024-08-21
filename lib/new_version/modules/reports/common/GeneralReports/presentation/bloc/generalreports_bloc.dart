import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/utils/request_state.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/usecases/get_all_reports_use_case.dart';

part 'generalreports_event.dart';
part 'generalreports_state.dart';

class GeneralReportsBloc
    extends Bloc<GeneralReportsEvent, GeneralReportsState> {
  final GetAllReportsUseCase _getAllReportsUseCase;

  GeneralReportsBloc(this._getAllReportsUseCase)
      : super(GeneralReportsState()) {
    on<GetAllReportsEvent>(_getAllReports);
  }

  FutureOr<void> _getAllReports(
      GetAllReportsEvent event, Emitter<GeneralReportsState> emit) async {
    emit(state.copyWith(getReportsState: RequestState.loading));
    final result = await _getAllReportsUseCase(event.moduleName);

    result.fold(
      (failure) => emit(state.copyWith(
        getReportsState: RequestState.error,
        getReportsMessage: failure.errorMessage,
      )),
      (reports) => emit(state.copyWith(
        getReportsState: RequestState.success,
        getReportData: reports,
      )),
    );
  }
}
