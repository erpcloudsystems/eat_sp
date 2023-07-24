import 'package:NextApp/new_version/modules/dashboard/domain/entities/tap_view_entity/task_entity.dart';

class LeaveApplicationModel extends TapViewEntity {
  const LeaveApplicationModel({
    required super.name,
    required super.title,
    required super.status,
  });

  factory LeaveApplicationModel.fromJson(Map<String, dynamic> json) => LeaveApplicationModel(
    name: json['name'] ?? 'none',
    title: json['employee_name'] ?? 'none',
    status: json['status'] ?? 'none',
  );
}
