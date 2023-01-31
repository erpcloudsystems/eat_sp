import 'list_model.dart';

class MaterialListModel extends ListModel<MaterialItemModel> {
  List<MaterialItemModel>? materialItemModel;

  MaterialListModel(List<MaterialItemModel>? list) : super(list);

  factory MaterialListModel.fromJson(Map<String, dynamic> json) {
    var _list = <MaterialItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new MaterialItemModel.fromJson(v));
      });
    }
    return MaterialListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class MaterialItemModel {
  final String id;
  final String requestType;
  final DateTime transactionDate;
  final String setWarehouse;
  final String status;

  MaterialItemModel({required this.id, required this.requestType, required this.setWarehouse, required this.status, required this.transactionDate});

  factory MaterialItemModel.fromJson(Map<String, dynamic> json) {
    return MaterialItemModel(
      id : json['name'] ?? 'none',
      requestType : json['material_request_type'] ?? 'none',
      setWarehouse : json['set_warehouse'] ?? 'none',
      status : json['status'] ?? 'none',
      transactionDate : DateTime.parse(json['transaction_date'] ?? 'none'),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['material_request_type'] = this.requestType;
    data['set_warehouse'] = this.setWarehouse;
    data['status'] = this.status;
    data['transaction_date'] = this.transactionDate;
    return data;
  }
}
