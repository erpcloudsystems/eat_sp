import '../list_model.dart';

class PurchaseOrderListModel extends ListModel<PurchaseOrderItemModel> {
  PurchaseOrderListModel(List<PurchaseOrderItemModel>? list) : super(list);

  factory PurchaseOrderListModel.fromJson(Map<String, dynamic> json) {
    var _list = <PurchaseOrderItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new PurchaseOrderItemModel.fromJson(v));
      });
    }
    return PurchaseOrderListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class PurchaseOrderItemModel {
  final String id;
  final String name;
  final DateTime transactionDate;
  final String setWarehouse;
  final String currency;
  final double grandTotal;
  final String status;

  PurchaseOrderItemModel(
      {required this.id,
        required this.name,
        required this.transactionDate,//TODO make sure that this exist
        required this.setWarehouse,
        required this.currency,
        required this.grandTotal,
        required this.status});

  factory PurchaseOrderItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderItemModel(
      id: json['name']??'none',
      name: json['supplier']??'none',
      transactionDate: DateTime.parse(json['transaction_date']??'none'),
      setWarehouse: json['set_warehouse']?? 'none',
      currency: json['currency']?? 'none',
      grandTotal: json['grand_total']?? 'none',
      status: json['status']?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['supplier'] = this.name;
    data['transaction_date'] = this.transactionDate;
    data['set_warehouse'] = this.setWarehouse;
    data['currency'] = this.currency;
    data['grand_total'] = this.grandTotal;
    data['status'] = this.status;
    return data;
  }
}
