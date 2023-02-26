import '../list_model.dart';

class EmployeeCheckinListModel extends ListModel<EmployeeCheckinItemModel> {
  EmployeeCheckinListModel(List<EmployeeCheckinItemModel>? list) : super(list);

  factory EmployeeCheckinListModel.fromJson(Map<String, dynamic> json) {
    var _list = <EmployeeCheckinItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new EmployeeCheckinItemModel.fromJson(v));
      });
    }
    return EmployeeCheckinListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class EmployeeCheckinItemModel {
  final String id;
  final String name;
  final String employee;
  final String logType;
  final DateTime time;
  final String shift;
  final String deviceId;
  final String status;

  EmployeeCheckinItemModel({
    required this.id,
    required this.name,
    required this.employee,
    required this.logType,
    required this.time,
    required this.shift,
    required this.deviceId,
    required this.status,
  });

  factory EmployeeCheckinItemModel.fromJson(Map<String, dynamic> json) {
    return EmployeeCheckinItemModel(
        id: json['name'] ?? 'none',
        name: json['employee_name'] ?? 'none',
        employee: json['employee'] ?? 'none',
        logType: json['log_type'] ?? 'none',
        time: DateTime.parse(json['time'] ?? 'none'),
        shift: json['shift'] ?? 'none',
        deviceId: json['device_id'] ?? 'none',
        status: 'Random');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['employee_name'] = this.name;
    data['employee'] = this.employee;
    data['log_type'] = this.logType;
    data['time'] = this.time;
    data['shift'] = this.shift;
    data['device_id'] = this.deviceId;
    return data;
  }
}
