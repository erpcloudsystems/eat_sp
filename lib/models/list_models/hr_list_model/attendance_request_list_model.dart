import '../list_model.dart';

class AttendanceRequestListModel extends ListModel<AttendanceRequestItemModel> {
  AttendanceRequestListModel(List<AttendanceRequestItemModel>? list)
      : super(list);

  factory AttendanceRequestListModel.fromJson(Map<String, dynamic> json) {
    var _list = <AttendanceRequestItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new AttendanceRequestItemModel.fromJson(v));
      });
    }
    return AttendanceRequestListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class AttendanceRequestItemModel {
  final String id;
  final String name;
  final String employee;
  final String department;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  final String docStatus;

  AttendanceRequestItemModel({
    required this.id,
    required this.name,
    required this.employee,
    required this.department,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.docStatus,
  });

  factory AttendanceRequestItemModel.fromJson(Map<String, dynamic> json) {
    String status ='';
    if(json['docstatus']== 0) {status="Draft";}
    if(json['docstatus']== 1) {status="Submitted";}
    if(json['docstatus']== 2) {status="Cancelled";}
    print('asfdsw2$status');
      return AttendanceRequestItemModel(
        id: json['name'] ?? 'none',
        name: json['employee_name'] ?? 'none',
        employee: json['employee'] ?? 'none',
        department: json['department'] ?? 'none',
        fromDate: DateTime.parse(json['from_date'] ?? 'none'),
        toDate: DateTime.parse(json['to_date'] ?? 'none'),
        reason: json['reason'] ?? 'none',
        docStatus: status,

      );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['employee_name'] = this.name;
    data['employee'] = this.employee;
    data['department'] = this.department;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['reason'] = this.reason;
    data['docstatus'] = this.docStatus;
    return data;
  }
}
