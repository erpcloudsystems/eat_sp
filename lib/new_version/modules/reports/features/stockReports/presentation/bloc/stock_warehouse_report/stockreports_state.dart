part of 'stockreports_bloc.dart';

class StockReportsState extends Equatable {
  final RequestState getWarehouseReportsState;
  final String getWarehouseReportMessage;
  final bool hasReachedMax;
  final List<WarehouseReportEntity> getWarehouseReportData;

  const StockReportsState({
    this.getWarehouseReportsState = RequestState.loading,
    this.getWarehouseReportMessage = '',
    this.getWarehouseReportData = const [],
    this.hasReachedMax = false,
  });

  StockReportsState copyWith({
    RequestState? getWarehouseReportsState,
    String? getWarehouseReportMessage,
    List<WarehouseReportEntity>? getWarehouseReportData,
    bool? hasReachedMax,
  }) =>
      StockReportsState(
        getWarehouseReportsState:
            getWarehouseReportsState ?? this.getWarehouseReportsState,
        getWarehouseReportMessage:
            getWarehouseReportMessage ?? this.getWarehouseReportMessage,
        getWarehouseReportData:
            getWarehouseReportData ?? this.getWarehouseReportData,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,    
      );

  @override
  List<Object> get props => [
        getWarehouseReportsState,
        getWarehouseReportMessage,
        getWarehouseReportData,
        hasReachedMax,
      ];
}
