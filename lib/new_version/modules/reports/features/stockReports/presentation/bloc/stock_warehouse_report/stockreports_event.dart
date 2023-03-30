part of 'stockreports_bloc.dart';

abstract class StockReportsEvent extends Equatable {
  const StockReportsEvent();

  @override
  List<Object> get props => [];
}

class GetWarehouseEvent extends StockReportsEvent {
  final WarehouseFilters warehouseFilters;

  const GetWarehouseEvent({required this.warehouseFilters});

  @override
  List<Object> get props => [warehouseFilters];
}

class ResetWarehouseEvent extends StockReportsEvent {
  const ResetWarehouseEvent();
}
