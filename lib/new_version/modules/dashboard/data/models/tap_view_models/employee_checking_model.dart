import 'package:NextApp/new_version/modules/dashboard/domain/entities/tap_view_entity/task_entity.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class EmployeeCheckingModel extends TapViewEntity {
  const EmployeeCheckingModel({
    required super.name,
    required super.title,
    required super.status,
    required super.subtitle,
  });

  factory EmployeeCheckingModel.fromJson(Map<String, dynamic> json) {
    DateTime originalDate = DateTime.parse(json['time']);

    String convertedDate =
        DateFormat("yyyy-MM-dd hh:mm a").format(originalDate);

    return EmployeeCheckingModel(
      name: json['name'] ?? 'none',
      title: json['employee_name'] ?? 'none',
      subtitle: convertedDate ,
      status: json['log_type'] ?? 'none',
    );
  }
}
