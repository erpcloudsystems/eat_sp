import '../list_model.dart';

class EmployeeListModel extends ListModel<EmployeeItemModel> {
  EmployeeListModel(List<EmployeeItemModel>? list) : super(list);

  factory EmployeeListModel.fromJson(Map<String, dynamic> json) {
    var _list = <EmployeeItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new EmployeeItemModel.fromJson(v));
      });
    }
    return EmployeeListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class EmployeeItemModel {
  final String id;
  final String name;
  final String department;
  final String designation;
  final String branch;
  final String attendanceDeviceId;
  final String status;

  EmployeeItemModel(
      {required this.id,
        required this.name,
        required this.department,
        required this.designation,
        required this.branch,
        required this.attendanceDeviceId,
        required this.status,
      });

  factory EmployeeItemModel.fromJson(Map<String, dynamic> json) {
    return EmployeeItemModel(
      id: json['name']??'none',
      name: json['employee_name']??'none',
      department: json['department']??'none',
      designation: json['designation']??'none',
      branch: json['branch']??'none',
      attendanceDeviceId: json['attendance_device_id']??'none',
      status: json['status']?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['employee_name'] = this.name;
    data['department'] = this.department;
    data['designation'] = this.designation;
    data['branch'] = this.branch;
    data['attendance_device_id'] = this.attendanceDeviceId;
    data['status'] = this.status;
    return data;
  }
}
