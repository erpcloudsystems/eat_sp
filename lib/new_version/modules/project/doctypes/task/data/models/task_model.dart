import 'package:equatable/equatable.dart';

import '../../domain/entities/task_entity.dart';
import 'depends_on_model.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required super.name,
    required super.subject,
    required super.project,
    required super.priority,
    required super.status,
    required super.type,
    required super.color,
    required super.expectedStartDate,
    required super.expectedEndDate,
    required super.description,
    required super.department,
    required super.company,
    required super.progress,
    required super.expectedTime,
    required super.dependsOn,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        name: json['name'] ?? 'none',
        subject: json['subject'] ?? 'none',
        priority: json['priority'] ?? 'none',
        status: json['status'] ?? 'none',
        type: json['type'] ?? 'none',
        color: json['color'] ?? 'none',
        expectedStartDate:
            DateTime.parse(json['exp_start_date'] ?? "2001-01-01"),
        expectedEndDate: DateTime.parse(json['exp_end_date'] ?? "2001-01-01"),
        expectedTime: json['expected_time'] ?? 'none',
        department: json['department'] ?? 'none',
        description: json['description'] ?? 'none',
        company: json['company'] ?? 'none',
        project: json['project'] ?? 'none',
        progress: json['progress'] ?? 'none',
        dependsOn: (List.from(
            (json['depends_on']).map((e) => DependsOnModel.fromJson(e)))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['subject'] = this.subject;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['type'] = this.type;
    data['color'] = this.color;
    data['exp_start_date'] = this.expectedStartDate;
    data['exp_end_date'] = this.expectedEndDate;
    data['expected_time'] = this.expectedTime;
    data['department'] = this.department;
    data['description'] = this.description;
    data['company'] = this.company;
    data['depends_on'] = this.dependsOn;
    data['project'] = this.project;
    data['progress'] = this.progress;
    return data;
  }
}
