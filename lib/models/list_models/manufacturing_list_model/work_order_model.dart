import '../list_model.dart';

class WorkOrderListModel extends ListModel<WorkOrderItemModel> {
  WorkOrderListModel(List<WorkOrderItemModel>? list) : super(list);

  factory WorkOrderListModel.fromJson(Map<String, dynamic> json) {
    List<WorkOrderItemModel> list = [];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        list.add(WorkOrderItemModel.fromJson(v));
      });
    }
    return WorkOrderListModel(list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class WorkOrderItemModel {
  final DateTime plannedStartDate, plannedEndDate;
  final String name, itemName, stockUom, status;
  final double quantity;

  WorkOrderItemModel({
    required this.plannedStartDate,
    required this.plannedEndDate,
    required this.itemName,
    required this.quantity,
    required this.stockUom,
    required this.status,
    required this.name,
   
   });

  factory WorkOrderItemModel.fromJson(Map<String, dynamic> json) => WorkOrderItemModel(
        plannedStartDate: DateTime.parse(json['planned_start_date'] ?? "2001-01-01"),
        plannedEndDate: DateTime.parse(json['planned_end_date'] ?? "2001-01-01"),
        stockUom: json['stock_uom'] ?? 'none',
        itemName: json['item_name'] ?? 'none',
        status: json['status'] ?? 'none',
        quantity: json['qty'] ?? 1.0,
        name: json['name'] ?? 'none',
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['planned_start_date'] = plannedStartDate;
    data['planned_end_date'] = plannedEndDate;
    data['item_name'] = itemName;
    data['stock_uom'] = stockUom;
    data['status'] = status;
    data['qty'] = quantity;
    data['name'] = name;
    return data;
  }
}
