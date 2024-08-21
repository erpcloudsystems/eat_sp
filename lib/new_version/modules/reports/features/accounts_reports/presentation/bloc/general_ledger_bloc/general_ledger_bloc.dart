import 'dart:async';

import '../../../data/models/general_ledger_filter.dart';
import '../../../domain/use_cases/get_general_ledger_report_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../../core/network/api_constance.dart';
import '../../../../../../../core/utils/request_state.dart';
import 'general_ledger_state.dart';

part 'general_ledger_event.dart';

class GeneralLedgerBloc extends Bloc<GeneralLedgerEvent, GeneralLedgerState> {
  final GetGeneralLedgerUseCase _getGeneralLedgerUseCase;

  GeneralLedgerBloc(this._getGeneralLedgerUseCase)
      : super(const GeneralLedgerState()) {
    on<GetGeneralLedgerEvent>(_getGeneralLedgerReport,
        transformer: droppable());
    on<ResetGeneralLedgerEvent>(_resetGeneralLedgerReports);
    on<ChangePartyTypeEvent>(_changePartyType);
  }

  FutureOr<void> _getGeneralLedgerReport(
      GetGeneralLedgerEvent event, Emitter<GeneralLedgerState> emit) async {
    if (state.hasReachedMax) return;

    if (state.getGeneralLedgerReportsState == RequestState.loading) {
      final result = await _getGeneralLedgerUseCase(event.generalLedgerFilters);

      result.fold(
        (failure) => emit(state.copyWith(
          getGeneralLedgerReportsState: RequestState.error,
          getGeneralLedgerReportMessage: failure.errorMessage,
        )),
        (generalLedgerReport) => emit(
          state.copyWith(
            getGeneralLedgerReportsState: RequestState.success,
            getGeneralLedgerReportData: generalLedgerReport,
            hasReachedMax: generalLedgerReport.length < ApiConstance.pageLength,
          ),
        ),
      );
    } else {
      final result = await _getGeneralLedgerUseCase(
        GeneralLedgerFilters(
          account: event.generalLedgerFilters.account,
          fromDate: event.generalLedgerFilters.fromDate,
          toDate: event.generalLedgerFilters.toDate,
          party: event.generalLedgerFilters.toDate,
          partyType: event.generalLedgerFilters.toDate,
          startKey: state.getGeneralLedgerReportData.length + 1,
        ),
      );
      result.fold(
        (failure) => emit(state.copyWith(
          getGeneralLedgerReportsState: RequestState.error,
          getGeneralLedgerReportMessage: failure.errorMessage,
        )),
        (generalLedgerReports) => emit(
          state.copyWith(
            getGeneralLedgerReportsState: RequestState.success,
            getGeneralLedgerReportData:
                List.of(state.getGeneralLedgerReportData)
                  ..addAll(generalLedgerReports),
            hasReachedMax:
                generalLedgerReports.length < ApiConstance.pageLength,
          ),
        ),
      );
    }
  }

  FutureOr<void> _resetGeneralLedgerReports(
      ResetGeneralLedgerEvent event, Emitter<GeneralLedgerState> emit) {
    emit(state.copyWith(
      getGeneralLedgerReportsState: RequestState.loading,
      getGeneralLedgerReportData: [],
      hasReachedMax: false,
    ));
  }

  FutureOr<void> _changePartyType(
      ChangePartyTypeEvent event, Emitter<GeneralLedgerState> emit) {
    emit(state.copyWith(
      isPartyType: event.isPartyType,
    ));
  }
}
