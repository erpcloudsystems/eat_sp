import '../list_model.dart';

class PurchaseInvoiceListModel extends ListModel<PurchaseInvoiceItemModel> {
  PurchaseInvoiceListModel(List<PurchaseInvoiceItemModel>? list) : super(list);

  factory PurchaseInvoiceListModel.fromJson(Map<String, dynamic> json) {
    var _list = <PurchaseInvoiceItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new PurchaseInvoiceItemModel.fromJson(v));
      });
    }
    return PurchaseInvoiceListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class PurchaseInvoiceItemModel {
  final String id;
  final String name;
  final DateTime postingDate;
  final double grandTotal;
  final String status;
  final String currency;

  PurchaseInvoiceItemModel({
    required this.id,
    required this.name,
    required this.postingDate, //TODO make sure that this exist
    required this.grandTotal,
    required this.status,
    required this.currency,
  });

  factory PurchaseInvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseInvoiceItemModel(
      id: json['name'] ?? 'none',
      name: json['supplier'] ?? 'none',
      postingDate: DateTime.parse(json['posting_date'] ?? 'none'),
      grandTotal: json['grand_total'] ?? 'none',
      currency: json['currency'] ?? 'none',
      status: json['status'] ?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['supplier'] = this.name;
    data['posting_date'] = this.postingDate;
    data['grand_total'] = this.grandTotal;
    data['currency'] = this.currency;
    data['status'] = this.status;
    return data;
  }
}
