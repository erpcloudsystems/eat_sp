import '../list_model.dart';

class PurchaseReceiptListModel extends ListModel<PurchaseReceiptItemModel> {

  PurchaseReceiptListModel(List<PurchaseReceiptItemModel>? list) : super(list);

  factory PurchaseReceiptListModel.fromJson(Map<String, dynamic> json) {
    var _list = <PurchaseReceiptItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new PurchaseReceiptItemModel.fromJson(v));
      });
    }
    return PurchaseReceiptListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class PurchaseReceiptItemModel {
  String id;
  String supplier;
  DateTime postingDate;
  String setWarehouse;
  String currency;
  String status;

  PurchaseReceiptItemModel(
      { required this.id,
        required  this.supplier,
        required  this.postingDate,
        required  this.setWarehouse,
        required  this.currency,
        required  this.status});

  factory PurchaseReceiptItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseReceiptItemModel(
    id : json['name'] ?? 'none',
    supplier : json['supplier'] ?? 'none',
    postingDate : DateTime.parse( json['posting_date'] ?? 'none'),
    setWarehouse : json['set_warehouse'] ?? 'none',
      currency : json['currency'] ?? 'none',
    status : json['status'] ?? 'none',);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['supplier'] = this.supplier;
    data['posting_date'] = this.postingDate;
    data['set_warehouse'] = this.setWarehouse;
    data['currency'] = this.setWarehouse;
    data['status'] = this.status;
    return data;
  }
}
