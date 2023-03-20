import 'package:equatable/equatable.dart';

class StockLedgerEntity extends Equatable {
  final String name,
      date,
      itemCode,
      itemName,
      itemGroup,
      stockUom,
      voucherNo,
      warehouse;
  final double inQty, outQty, qtyAfterTransaction;

  const StockLedgerEntity({
    required this.name,
    required this.itemName,
    required this.itemGroup,
    required this.stockUom,
    required this.date,
    required this.itemCode,
    required this.voucherNo,
    required this.warehouse,
    required this.inQty,
    required this.outQty,
    required this.qtyAfterTransaction,
  });

  @override
  List<Object?> get props => [
        name,
        date,
        itemCode,
        itemName,
        itemGroup,
        stockUom,
        voucherNo,
        warehouse,
        inQty,
        outQty,
        qtyAfterTransaction,
      ];
}
