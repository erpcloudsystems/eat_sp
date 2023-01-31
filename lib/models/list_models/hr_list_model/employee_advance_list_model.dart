import '../list_model.dart';

class EmployeeAdvanceListModel extends ListModel<EmployeeAdvanceItemModel> {
  EmployeeAdvanceListModel(List<EmployeeAdvanceItemModel>? list) : super(list);

  factory EmployeeAdvanceListModel.fromJson(Map<String, dynamic> json) {
    var _list = <EmployeeAdvanceItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new EmployeeAdvanceItemModel.fromJson(v));
      });
    }
    return EmployeeAdvanceListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class EmployeeAdvanceItemModel {
  final String id;
  final String name;
  final String employee;
  final String department;
  final DateTime postingDate;
  final String purpose;
  final double advanceAmount;
  final String status;
  final String company;
  final String advanceAccount;

  EmployeeAdvanceItemModel(
      {required this.id,
        required this.name,
        required this.employee,
        required this.department,
        required this.postingDate,
        required this.purpose,
        required this.advanceAmount,
        required this.status,
        required this.company,
        required this.advanceAccount,
      });

  factory EmployeeAdvanceItemModel.fromJson(Map<String, dynamic> json) {
    return EmployeeAdvanceItemModel(
      id: json['name']??'none',
      name: json['employee_name']??'none',
      employee: json['employee']??'none',
      department: json['department']??'none',
      postingDate: DateTime.parse(json['posting_date'] ?? 'none'),
      purpose: json['purpose']??'none',
      advanceAmount: json['advance_amount']??'none',
      status: json['status']??'none',
      company: json['company']??'none',
      advanceAccount: json['advance_account']?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['employee_name'] = this.name;
    data['employee'] = this.employee;
    data['department'] = this.department;
    data['posting_date'] = this.postingDate;
    data['purpose'] = this.purpose;
    data['advance_amount'] = this.advanceAmount;
    data['status'] = this.status;
    data['company'] = this.company;
    data['advance_account'] = this.advanceAccount;
    return data;
  }
}
