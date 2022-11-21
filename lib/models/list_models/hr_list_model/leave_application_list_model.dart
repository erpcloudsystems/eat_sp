import 'package:next_app/models/list_models/list_model.dart';

class LeaveApplicationListModel extends ListModel<LeaveApplicationItemModel> {
  LeaveApplicationListModel(List<LeaveApplicationItemModel>? list) : super(list);

  factory LeaveApplicationListModel.fromJson(Map<String, dynamic> json) {
    var _list = <LeaveApplicationItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new LeaveApplicationItemModel.fromJson(v));
      });
    }
    return LeaveApplicationListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class LeaveApplicationItemModel {
  final String id;
  final String name;
  final String department;
  final String leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final double totalLeaveDays;
  final String status;

  LeaveApplicationItemModel(
      {required this.id,
        required this.name,
        required this.department,
        required this.leaveType,
        required this.fromDate,
        required this.totalLeaveDays,
        required this.toDate,
        required this.status,
      });

  factory LeaveApplicationItemModel.fromJson(Map<String, dynamic> json) {
    return LeaveApplicationItemModel(
      id: json['name']??'none',
      name: json['employee_name']??'none',
      department: json['department']??'none',
      leaveType: json['leave_type']??'none',
      fromDate: DateTime.parse(json['from_date']??'none'),
      toDate: DateTime.parse(json['to_date']??'none'),
      totalLeaveDays: json['total_leave_days'] ?? 'none',
      status: json['status']?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['employee_name'] = this.name;
    data['department'] = this.department;
    data['leave_type'] = this.leaveType;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['total_leave_days'] = this.totalLeaveDays;
    data['status'] = this.status;
    return data;
  }
}
