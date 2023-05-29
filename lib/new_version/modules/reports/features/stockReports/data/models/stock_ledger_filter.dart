import 'package:equatable/equatable.dart';

class StockLedgerFilters extends Equatable {
  final String warehouseFilter;
  final String fromDate;
  final String toDate;
  final String? itemCode;
  final String? itemGroup;
  final int? startKey;

  const StockLedgerFilters({
    required this.warehouseFilter,
    required this.fromDate,
    required this.toDate,
    this.itemCode,
    this.itemGroup,
    this.startKey = 0,
  });

  @override
  List<Object?> get props => [
        warehouseFilter,
        fromDate,
        toDate,
        itemCode,
        itemGroup,
        startKey,
      ];
}
