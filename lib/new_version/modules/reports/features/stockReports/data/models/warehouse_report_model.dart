import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/entities/warehouse_report_entity.dart';

class WarehouseReportModel extends WarehouseReportEntity {
  const WarehouseReportModel({
    required super.itemCode,
    required super.itemName,
    required super.itemGroup,
    required super.actualQty,
    required super.stockUom,
  });

  factory WarehouseReportModel.fromJson(Map<String, dynamic> json) =>
      WarehouseReportModel(
        itemCode: json['item_code'] ?? 'none',
        itemName: json['item_name'] ?? 'none',
        itemGroup: json['item_group'] ?? 'none',
        actualQty: json['actual_qty'] ?? 'none',
        stockUom: json['stock_uom'] ?? 'none',
      );

  @override
  List<Object?> get props => [
        itemCode,
        itemName,
        itemGroup,
        actualQty,
        stockUom,
      ];
}
