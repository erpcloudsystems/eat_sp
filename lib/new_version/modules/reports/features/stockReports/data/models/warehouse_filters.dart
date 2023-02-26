import 'package:equatable/equatable.dart';

class WarehouseFilters extends Equatable {
  final String warehouseFilter;
  final String? itemFilter;
  final int? startKey;

  const WarehouseFilters({
    required this.warehouseFilter,
    this.itemFilter,
    this.startKey = 0,
  });

  @override
  List<Object?> get props => [
        warehouseFilter,
        itemFilter,
        startKey,
      ];
}
