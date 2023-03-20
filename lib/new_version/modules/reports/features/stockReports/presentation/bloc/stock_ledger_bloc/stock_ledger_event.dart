part of 'stock_ledger_bloc.dart';

@immutable
abstract class StockLedgerEvent extends Equatable {
  const StockLedgerEvent();

  @override
  List<Object> get props => [];
}

class GetStockLedgerEvent extends StockLedgerEvent {
  final StockLedgerFilters stockLedgerFilters;

  const GetStockLedgerEvent({
    required this.stockLedgerFilters,
  });

  @override
  List<Object> get props => [stockLedgerFilters];
}

class ResetStockLedgerEvent extends StockLedgerEvent {
  const ResetStockLedgerEvent();
}
