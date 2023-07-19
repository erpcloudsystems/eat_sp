import 'package:NextApp/new_version/modules/dashboard/domain/entities/tap_view_entity/task_entity.dart';

class TaskModel extends TapViewEntity {

  const TaskModel({
    required super.name,
    required super.title,
    required super.status,
    required super.subtitle,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        name: json['name'] ?? 'none',
        title: json['subject'] ?? 'none',
        subtitle: json['project'] ?? 'none',
        status: json['status'] ?? 'none',
      );
}
