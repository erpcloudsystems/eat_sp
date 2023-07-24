import 'package:NextApp/new_version/modules/dashboard/domain/entities/tap_view_entity/task_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

class EmployeeCheckingModel extends TapViewEntity {
  const EmployeeCheckingModel({
    required super.name,
    required super.title,
    required super.status,
  });

  factory EmployeeCheckingModel.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['time']);

    var timeAgo = timeago.format(date);
    return EmployeeCheckingModel(
      name: json['name'] ?? 'none',
      title: json['employee_name'] ?? 'none',
      status: timeAgo,
    );
  }
}
