import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/entities/stock_ledger_entity.dart';

class StockLedgerReportModel extends StockLedgerEntity {
  const StockLedgerReportModel({
    required super.name,
    required super.itemName,
    required super.itemGroup,
    required super.stockUom,
    required super.date,
    required super.itemCode,
    required super.voucherNo,
    required super.warehouse,
    required super.inQty,
    required super.outQty,
    required super.qtyAfterTransaction,
  });

  factory StockLedgerReportModel.fromJson(Map<String, dynamic> json) =>
      StockLedgerReportModel(
        name: json['name'],
        date: json['date'],
        itemCode: json['item_code'],
        itemName: json['item_name'],
        itemGroup: json['item_group'],
        stockUom: json['stock_uom'],
        inQty: json['in_qty'].toDouble(),
        outQty: json['out_qty'].toDouble(),
        qtyAfterTransaction: json['qty_after_transaction'],
        voucherNo: json['voucher_no'],
        warehouse: json['warehouse'],
      );

  @override
  List<Object?> get props => [
        name,
        itemName,
        itemGroup,
        stockUom,
        date,
        itemCode,
        voucherNo,
        warehouse,
        inQty,
        outQty,
        qtyAfterTransaction,
      ];
}
