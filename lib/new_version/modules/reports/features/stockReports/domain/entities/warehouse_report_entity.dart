import 'package:equatable/equatable.dart';

class WarehouseReportEntity extends Equatable {
  final String itemCode, itemName, itemGroup, stockUom;
  final double actualQty;

  const WarehouseReportEntity({
    required this.itemCode,
    required this.itemName,
    required this.itemGroup,
    required this.actualQty,
    required this.stockUom,
  });

  @override
  List<Object?> get props => [
        itemCode,
        itemName,
        itemGroup,
        actualQty,
        stockUom,
      ];
}
