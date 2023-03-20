part of 'stock_ledger_bloc.dart';

class StockLedgerState extends Equatable {
  final RequestState getStockLedgerReportsState;
  final String getStockLedgerReportMessage;
  final bool hasReachedMax;
  final List<StockLedgerEntity> getStockLedgerReportData;

  const StockLedgerState({
    this.getStockLedgerReportsState = RequestState.loading,
    this.getStockLedgerReportMessage = '',
    this.getStockLedgerReportData = const [],
    this.hasReachedMax = false,
  });

  StockLedgerState copyWith({
    RequestState? getStockLedgerReportsState,
    String? getStockLedgerReportMessage,
    List<StockLedgerEntity>? getStockLedgerReportData,
    bool? hasReachedMax,
  }) =>
      StockLedgerState(
        getStockLedgerReportsState:
            getStockLedgerReportsState ?? this.getStockLedgerReportsState,
        getStockLedgerReportMessage:
            getStockLedgerReportMessage ?? this.getStockLedgerReportMessage,
        getStockLedgerReportData:
            getStockLedgerReportData ?? this.getStockLedgerReportData,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );

  @override
  List<Object?> get props => [
        getStockLedgerReportsState,
        getStockLedgerReportData,
        getStockLedgerReportMessage,
        hasReachedMax,
      ];
}
