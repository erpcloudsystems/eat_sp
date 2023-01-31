import '../list_model.dart';

class CustomerListModel extends ListModel<CustomerItemModel> {
  CustomerListModel(List<CustomerItemModel>? list) : super(list);

  factory CustomerListModel.fromJson(Map<String, dynamic> json) {
    var _list = <CustomerItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new CustomerItemModel.fromJson(v));
      });
    }
    return CustomerListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class CustomerItemModel {
  final String id;
  final String name;
  final String customerGroup;
  final String territory;
  final String customerType;
  final String currency;
  final String mobile;
  final String status;

  CustomerItemModel({
    required this.id,
    required this.name,
    required this.customerGroup,
    required this.territory,
    required this.customerType,
    required this.currency,
    required this.mobile,
    required this.status,
  });

  factory CustomerItemModel.fromJson(Map<String, dynamic> json) {
    return CustomerItemModel(
      id: json['name'] ?? 'none',
      name: json['customer_name'] ?? 'none',
      customerGroup: json['customer_group'] ?? 'none',
      territory: json['territory'] ?? 'none',
      customerType: json['customer_type'] ?? 'none',
      currency: json['default_currency'] ?? 'none',
      mobile: json['mobile_no'] ?? 'none',
      status: 'Random',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['customer_name'] = this.name;
    data['customer_group'] = this.customerGroup;
    data['territory'] = this.territory;
    data['customer_type'] = this.customerType;
    data['default_currency'] = this.currency;
    data['mobile_no'] = this.mobile;
    return data;
  }
}
