import '../list_model.dart';

class SupplierQuotationListModel extends ListModel<SupplierQuotationItemModel> {
  SupplierQuotationListModel(List<SupplierQuotationItemModel>? list)
      : super(list);

  factory SupplierQuotationListModel.fromJson(Map<String, dynamic> json) {
    var _list = <SupplierQuotationItemModel>[];

    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new SupplierQuotationItemModel.fromJson(v));
      });
    }

    return SupplierQuotationListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class SupplierQuotationItemModel {
  final String id;
  final String name;
  final String transactionDate;
  final String validTill;
  final String currency;
  final double grandTotal;
  final String status;

  SupplierQuotationItemModel({
    required this.id,
    required this.name,
    required this.transactionDate,
    required this.validTill,
    required this.currency,
    required this.grandTotal,
    required this.status,
  });

  factory SupplierQuotationItemModel.fromJson(Map<String, dynamic> json) {
    return SupplierQuotationItemModel(
      id: json['name'] ?? 'none',
      name: json['supplier'] ?? 'none',
      transactionDate: json['transaction_date'] ?? 'none',
      validTill: json['valid_till'] ?? 'none',
      currency: json['currency'] ?? 'none',
      //transactionDate: DateTime.parse(json['transaction_date'] ?? 'none'),
      //validTill: DateTime.parse(json['valid_till'] ?? '1999-01-01'),
      grandTotal: json['grand_total']?? 'none',
      status: json['status']?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['supplier'] = this.name;
    data['transaction_date'] = this.transactionDate;
    data['valid_till'] = this.validTill;
    data['currency'] = this.currency;
    data['grand_total'] = this.grandTotal;
    data['status'] = this.status;
    return data;
  }
}
