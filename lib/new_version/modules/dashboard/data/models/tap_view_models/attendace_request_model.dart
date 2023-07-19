import 'package:NextApp/new_version/modules/dashboard/domain/entities/tap_view_entity/task_entity.dart';

class AttendanceRequestModel extends TapViewEntity {
  const AttendanceRequestModel({
    required super.name,
    required super.title,
    required super.status,
    required super.subtitle,
  });

  factory AttendanceRequestModel.fromJson(Map<String, dynamic> json) => AttendanceRequestModel(
    name: json['name'] ?? 'none',
    title: json['employee_name'] ?? 'none',
    subtitle: json['from_date'] ?? 'none',
    status: json['docstatus'] == 0 ? 'Draft': json['docstatus'] == 1 ?'Submitted': 'Cancelled',
  );
}
