import '../list_model.dart';

class ExpenseClaimListModel extends ListModel<ExpenseClaimItemModel> {
  ExpenseClaimListModel(List<ExpenseClaimItemModel>? list) : super(list);

  factory ExpenseClaimListModel.fromJson(Map<String, dynamic> json) {
    var _list = <ExpenseClaimItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new ExpenseClaimItemModel.fromJson(v));
      });
    }
    return ExpenseClaimListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class ExpenseClaimItemModel {
  final String id;
  final String name;
  final String employee;
  final String department;
  final DateTime postingDate;
  final double grandTotal;
  final String status;

  ExpenseClaimItemModel({
    required this.id,
    required this.name,
    required this.employee,
    required this.department,
    required this.postingDate,
    required this.grandTotal,
    required this.status,
  });

  factory ExpenseClaimItemModel.fromJson(Map<String, dynamic> json) {
    return ExpenseClaimItemModel(
      id: json['name'] ?? 'none',
      name: json['employee_name'] ?? 'none',
      employee: json['employee'] ?? 'none',
      department: json['department'] ?? 'none',
      postingDate: DateTime.parse(json['posting_date'] ?? 'none'),
      grandTotal: json['grand_total'] ?? 'none',
      status: json['status'] ?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['employee_name'] = this.name;
    data['employee'] = this.employee;
    data['department'] = this.department;
    data['posting_date'] = this.postingDate;
    data['grand_total'] = this.grandTotal;
    data['status'] = this.status;
    return data;
  }
}
