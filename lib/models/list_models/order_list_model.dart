import 'package:next_app/models/list_models/list_model.dart';

class OrderListModel extends ListModel<OrderItemModel> {
  OrderListModel(List<OrderItemModel>? list) : super(list);

  factory OrderListModel.fromJson(Map<String, dynamic> json) {
    var _list = <OrderItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new OrderItemModel.fromJson(v));
      });
    }
    return OrderListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class OrderItemModel {
  final String id;
  final String customerName;
  final String customerAddress;
  final String currency;
  final DateTime transactionDate;
  final double grandTotal;
  final String status;

  OrderItemModel(
      {required this.id,
      required this.customerName,
      required this.customerAddress,
      required this.currency,
      required this.transactionDate,
      required this.grandTotal,
      required this.status});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
        id: json['name'] ?? 'none',
        customerName: json['customer_name'] ?? 'none',
        customerAddress: json['customer_address'] ?? 'none',
        currency: json['currency'] ?? 'none',
        transactionDate: DateTime.parse(json['transaction_date'] ?? ''),
        grandTotal: json['grand_total'] ?? 'none',
        status: json['status'] ?? 'none');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.id;
    data['customer_name'] = this.customerName;
    data['customer_address'] = this.customerAddress;
    data['currency'] = this.currency;
    data['transaction_date'] = this.transactionDate;
    data['grand_total'] = this.grandTotal;
    data['status'] = this.status;
    return data;
  }
}
