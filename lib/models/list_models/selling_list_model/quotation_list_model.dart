import '../list_model.dart';

class QuotationListModel extends ListModel<QuotationItemModel> {
  QuotationListModel(List<QuotationItemModel>? list) : super(list);

  factory QuotationListModel.fromJson(Map<String, dynamic> json) {
    var _list = <QuotationItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new QuotationItemModel.fromJson(v));
      });
    }
    return QuotationListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class QuotationItemModel {
  final String id;
  final String quotationTo;
  final String customerName;
  final String currency;
  final DateTime transactionDate;
  final double grandTotal;
  final String status;

  QuotationItemModel({
    required this.id,
    required this.quotationTo,
    required this.customerName,
    required this.currency,
    required this.transactionDate,
    required this.grandTotal,
    required this.status,
  });

  factory QuotationItemModel.fromJson(Map<String, dynamic> json) {
    return QuotationItemModel(
      id: json['name'] ?? 'none',
      quotationTo: json['quotation_to'] ?? 'none',
      customerName: json['customer_name'] ?? 'none',
      currency: json['currency'] ?? 'none',
      transactionDate: DateTime.parse(json['transaction_date'] ?? 'none'),
      grandTotal: json['grand_total'] ?? 'none',
      status: json['status'] ?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['quotation_to'] = this.quotationTo;
    data['customer_name'] = this.customerName;
    data['currency'] = this.currency;
    data['transaction_date'] = this.transactionDate;
    data['grand_total'] = this.grandTotal;
    data['status'] = this.status;
    return data;
  }
}
