import 'package:next_app/models/list_models/list_model.dart';

class SalesInvoiceListModel extends ListModel<SalesInvoiceItemModel> {
  SalesInvoiceListModel(List<SalesInvoiceItemModel>? list) : super(list);

  factory SalesInvoiceListModel.fromJson(Map<String, dynamic> json) {
    var _list = <SalesInvoiceItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new SalesInvoiceItemModel.fromJson(v));
      });
    }
    return SalesInvoiceListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class SalesInvoiceItemModel {
  final String id;
  final String customerName;
  final String customerAddress;
  final String currency;
  final DateTime postingDate;
  final double grandTotal;
  final String status;

  SalesInvoiceItemModel(
      {required this.id,
      required this.customerName,
      required this.customerAddress,
      required this.currency,
      required this.postingDate,
      required this.grandTotal,
      required this.status});

  factory SalesInvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return SalesInvoiceItemModel(
      id: json['name']??'none',
      customerName: json['customer_name']??'none',
      customerAddress: json['customer_address']?? 'none',
      currency: json['currency']?? 'none',
      postingDate: DateTime.parse(json['posting_date']??'none'),
      grandTotal: json['grand_total']?? 'none',
      status: json['status']?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['customer_name'] = this.customerName;
    data['customer_address'] = this.customerAddress;
    data['currency'] = this.currency;
    data['posting_date'] = this.postingDate;
    data['grand_total'] = this.grandTotal;
    data['status'] = this.status;
    return data;
  }
}
