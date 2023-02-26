import '../list_model.dart';

class StockEntryListModel extends ListModel<StockEntryItemModel> {
  StockEntryListModel(List<StockEntryItemModel>? list) : super(list);

  factory StockEntryListModel.fromJson(Map<String, dynamic> json) {
    var _list = <StockEntryItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new StockEntryItemModel.fromJson(v));
      });
    }
    return StockEntryListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class StockEntryItemModel {
  String id;
  String stockEntryType;
  String fromWarehouse;
  String toWarehouse;
  int docStatus;
  DateTime postingDate;

  StockEntryItemModel(
      {required this.id,
      required this.stockEntryType,
      required this.fromWarehouse,
      required this.toWarehouse,
      required this.docStatus,
      required this.postingDate});

  factory StockEntryItemModel.fromJson(Map<String, dynamic> json) {
    return StockEntryItemModel(
      id: json['name'] ?? 'none',
      stockEntryType: json['stock_entry_type'] ?? 'none',
      fromWarehouse: json['from_warehouse'] ?? 'none',
      toWarehouse: json['to_warehouse'] ?? 'none',
      docStatus: json['docstatus'] ?? 0,
      postingDate: DateTime.parse(json['posting_date'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['stock_entry_type'] = this.stockEntryType;
    data['from_warehouse'] = this.fromWarehouse;
    data['to_warehouse'] = this.toWarehouse;
    data['docstatus'] = this.docStatus;
    data['posting_date'] = this.postingDate;
    return data;
  }
}
