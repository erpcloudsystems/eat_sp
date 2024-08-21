import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../../core/network/api_constance.dart';
import '../../../../../../../core/utils/request_state.dart';
import '../../../data/models/accounts_receivable_filters.dart';
import '../../../domain/entities/account_receivable_entity.dart';
import '../../../domain/use_cases/get_account_receivable_reports_use_case.dart';

part 'accounts_receivable_bloc_event.dart';
part 'accounts_receivable_bloc_state.dart';

class AccountsReceivableBloc
    extends Bloc<AccountsReceivableEvent, AccountsReceivableState> {
  final GetAccountReceivableReportsUseCase getAccountReceivableReportsUseCase;

  AccountsReceivableBloc(this.getAccountReceivableReportsUseCase)
      : super(const AccountsReceivableState()) {
    on<GetAccountReceivableReportEvent>(getAccountReceivableReport,
        transformer: droppable());
    on<ResetAccountReceivableReportEvent>(resetAccountReceivableReports);
  }

  FutureOr<void> getAccountReceivableReport(
      GetAccountReceivableReportEvent event,
      Emitter<AccountsReceivableState> emit) async {
    if (state.hasReachedMax) return;

    if (state.accountsReceivableReportState == RequestState.loading) {
      final result = await getAccountReceivableReportsUseCase(event.filters);

      result.fold(
        (failure) => emit(state.copyWith(
          accountsReceivableReportState: RequestState.error,
          accountReceivableReportMessage: failure.errorMessage,
        )),
        (accountReceivableReport) => emit(state.copyWith(
          accountsReceivableReportState: RequestState.success,
          accountReceivableReportData: accountReceivableReport,
          hasReachedMax:
              accountReceivableReport.length < ApiConstance.pageLength,
        )),
      );
    } else {
      final result =
          await getAccountReceivableReportsUseCase(AccountReceivableFilters(
        customerCode: event.filters.customerCode,
        customerName: event.filters.customerName,
        salesPersonName: event.filters.salesPersonName,
        toDate: event.filters.toDate,
        startKey: state.accountReceivableReportData.length + 1,
      ));

      result.fold(
        (failure) => emit(state.copyWith(
          accountsReceivableReportState: RequestState.error,
          accountReceivableReportMessage: failure.errorMessage,
        )),
        (accountReceivableReports) => emit(state.copyWith(
          accountsReceivableReportState: RequestState.success,
          accountReceivableReportData:
              List.of(state.accountReceivableReportData)
                ..addAll(accountReceivableReports),
          hasReachedMax:
              accountReceivableReports.length < ApiConstance.pageLength,
        )),
      );
    }
  }

  FutureOr<void> resetAccountReceivableReports(
      ResetAccountReceivableReportEvent event,
      Emitter<AccountsReceivableState> emit) async {
        emit(state.copyWith(
          accountsReceivableReportState: RequestState.loading,
          accountReceivableReportData: [],
          hasReachedMax: false,
        ));
      }
}
