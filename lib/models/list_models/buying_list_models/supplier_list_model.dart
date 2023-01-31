import '../list_model.dart';

class SupplierListModel extends ListModel<SupplierItemModel> {
  SupplierListModel(List<SupplierItemModel>? list) : super(list);

  factory SupplierListModel.fromJson(Map<String, dynamic> json) {
    var _list = <SupplierItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new SupplierItemModel.fromJson(v));
      });
    }
    return SupplierListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class SupplierItemModel {
  final String id;
  final String name;
  final String supplierGroup;
  final String supplierType;
  final String country;
  final String currency;
  final String mobile;
  final String status;

  SupplierItemModel({
    required this.id,
    required this.name,
    required this.supplierGroup,
    required this.supplierType,
    required this.country,
    required this.currency,
    required this.mobile,
    required this.status,
  });

  factory SupplierItemModel.fromJson(Map<String, dynamic> json) {
    return SupplierItemModel(
      id: json['name'] ?? 'none',
      name: json['supplier_name'] ?? 'none',
      supplierGroup: json['supplier_group'] ?? 'none',
      supplierType: json['supplier_type'] ?? 'none',
      country: json['country'] ?? 'none',
      currency: json['default_currency'] ?? 'none',
      mobile: json['mobile_no'] ?? 'none',
      status: 'Random',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['supplier_name'] = this.name;
    data['supplier_group'] = this.supplierGroup;
    data['supplier_type'] = this.supplierType;
    data['country'] = this.country;
    data['default_currency'] = this.currency;
    data['mobile_no'] = this.mobile;
    return data;
  }
}
