import 'package:NextApp/new_version/modules/dashboard/domain/entities/tap_view_entity/task_entity.dart';

class AttendanceRequestModel extends TapViewEntity {
  const AttendanceRequestModel({
    required super.name,
    required super.title,
    required super.status,
  });

  factory AttendanceRequestModel.fromJson(Map<String, dynamic> json) => AttendanceRequestModel(
    name: json['name'] ?? 'none',
    title: json['employee_name'] ?? 'none',
    status: json['from_date'] ?? 'none',
  );
}
