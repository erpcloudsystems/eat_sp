import '../list_model.dart';

class CustomerVisitListModel extends ListModel<CustomerVisitItemModel> {
  CustomerVisitListModel(List<CustomerVisitItemModel>? list) : super(list);

  factory CustomerVisitListModel.fromJson(Map<String, dynamic> json) {
    var _list = <CustomerVisitItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new CustomerVisitItemModel.fromJson(v));
      });
    }
    return CustomerVisitListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class CustomerVisitItemModel {
  final String id;
  final String customer;
  final String customerAddress;
  final DateTime postingDate;
  final String time;
  final String status;

  CustomerVisitItemModel({
    required this.id,
    required this.customer,
    required this.customerAddress,
    required this.postingDate,
    required this.time,
    required this.status,
  });

  factory CustomerVisitItemModel.fromJson(Map<String, dynamic> json) {
    return CustomerVisitItemModel(
      id: json['name'] ?? 'none',
      customer: json['customer'] ?? 'none',
      customerAddress: json['customer_address'] ?? 'none',
      postingDate: DateTime.parse(json['posting_date'] ?? "2001-01-01"),
      time: json['time'] ?? "11:11:11",
      status: 'Random',

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['customer'] = this.customer;
    data['customer_address'] = this.customerAddress;
    data['posting_date'] = this.postingDate;
    data['time'] = this.time;

    return data;
  }
}
