import '../list_model.dart';

class CustomerListModel extends ListModel<CustomerItemModel> {
  CustomerListModel(List<CustomerItemModel>? super.list);

  factory CustomerListModel.fromJson(Map<String, dynamic> json) {
    var list = <CustomerItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        list.add(CustomerItemModel.fromJson(v));
      });
    }
    return CustomerListModel(list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class CustomerItemModel {
  final String id;
  final String name;
  final String nameAr;
  final String customerGroup;
  final String territory;
  final String customerType;
  final String currency;
  final String mobile;
  final String status;
  final String addressName;

  CustomerItemModel({
    required this.id,
    required this.name,
    required this.customerGroup,
    required this.territory,
    required this.customerType,
    required this.currency,
    required this.mobile,
    required this.status,
    required this.nameAr,
    required this.addressName,
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
      nameAr: json['customer_name_in_arabic'] ?? 'none',
      addressName: json['address_name'] ?? 'none',
      status: 'Random',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = id;
    data['customer_name'] = name;
    data['customer_group'] = customerGroup;
    data['territory'] = territory;
    data['customer_type'] = customerType;
    data['default_currency'] = currency;
    data['mobile_no'] = mobile;
    return data;
  }
}
