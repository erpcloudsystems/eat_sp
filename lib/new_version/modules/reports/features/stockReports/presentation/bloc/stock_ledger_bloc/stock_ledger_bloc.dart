import 'dart:async';
import 'package:NextApp/new_version/modules/reports/features/stockReports/data/models/stock_ledger_filter.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/entities/stock_ledger_entity.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/usecases/get_stock_ledger_report_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../../../../../core/network/api_constance.dart';
import '../../../../../../../core/utils/request_state.dart';

part 'stock_ledger_event.dart';

part 'stock_ledger_state.dart';

class StockLedgerBloc extends Bloc<StockLedgerEvent, StockLedgerState> {
  final GetStockLedgerUseCase _getStockLedgerUseCase;

  StockLedgerBloc(this._getStockLedgerUseCase) : super(StockLedgerState()) {
    on<GetStockLedgerEvent>(_getStockLedgerReports, transformer: droppable());
    on<ResetStockLedgerEvent>(_resetStockLedgerReports);
  }

  FutureOr<void> _getStockLedgerReports(
      GetStockLedgerEvent event, Emitter<StockLedgerState> emit) async {
    if (state.hasReachedMax) return;

    if (state.getStockLedgerReportsState == RequestState.loading) {
      final result = await _getStockLedgerUseCase(event.stockLedgerFilters);
      result.fold(
          (failure) => emit(state.copyWith(
                getStockLedgerReportsState: RequestState.error,
                getStockLedgerReportMessage: failure.errorMessage,
              )),
          (stockLedgerReport) => emit(state.copyWith(
                getStockLedgerReportsState: RequestState.success,
                getStockLedgerReportData: stockLedgerReport,
                hasReachedMax: false,
              )));
    } else {
      final result = await _getStockLedgerUseCase(StockLedgerFilters(
        warehouseFilter: event.stockLedgerFilters.warehouseFilter,
        itemCode: event.stockLedgerFilters.itemCode,
        itemGroup: event.stockLedgerFilters.itemGroup,
        fromDate: event.stockLedgerFilters.fromDate,
        toDate: event.stockLedgerFilters.toDate,
        startKey: state.getStockLedgerReportData.length + 1,
      ));
      result.fold(
            (failure) => emit(state.copyWith(
          getStockLedgerReportsState: RequestState.error,
          getStockLedgerReportMessage: failure.errorMessage,
        )),
            (stockLedgerReport) => emit(
          state.copyWith(
            getStockLedgerReportsState: RequestState.success,
            getStockLedgerReportData: List.of(state.getStockLedgerReportData)
              ..addAll(stockLedgerReport),
            hasReachedMax: stockLedgerReport.length < ApiConstance.pageLength,
          ),
        ),
      );
    }
  }

  FutureOr<void> _resetStockLedgerReports(
      ResetStockLedgerEvent event, Emitter<StockLedgerState> emit) {
    emit(state.copyWith(
      getStockLedgerReportsState: RequestState.loading,
      getStockLedgerReportData: [],
      hasReachedMax: false,
    ));
  }
}
