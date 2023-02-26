import 'package:equatable/equatable.dart';

import '../list_model.dart';

class TaskListModel extends ListModel<TaskItemModel> {
  TaskListModel(List<TaskItemModel>? list) : super(list);

  factory TaskListModel.fromJson(Map<String, dynamic> json) {
    var _list = <TaskItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new TaskItemModel.fromJson(v));
      });
    }
    return TaskListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class TaskItemModel extends Equatable {
  final String name,
      subject,
      project,
      priority,
      status,
      type,
      color,
      description,
      department,
      company;
  final double progress, expectedTime;
  final List<String> dependsOn;
  final DateTime expectedStartDate, expectedEndDate;

  TaskItemModel({
    required this.name,
    required this.subject,
    required this.project,
    required this.priority,
    required this.status,
    required this.type,
    required this.color,
    required this.expectedStartDate,
    required this.expectedEndDate,
    required this.description,
    required this.department,
    required this.company,
    required this.progress,
    required this.expectedTime,
    required this.dependsOn,
  });

  factory TaskItemModel.fromJson(Map<String, dynamic> json) {
    return TaskItemModel(
      name: json['name'] ?? 'none',
      subject: json['subject'] ?? 'none',
      priority: json['priority'] ?? 'none',
      status: json['status'] ?? 'none',
      type: json['type'] ?? 'none',
      color: json['color'] ?? 'none',
      expectedStartDate: DateTime.parse(json['exp_start_date'] ?? "2001-01-01"),
      expectedEndDate: DateTime.parse(json['exp_end_date'] ?? "2001-01-01"),
      expectedTime: json['expected_time'] ?? 'none',
      department: json['department'] ?? 'none',
      description: json['description'] ?? 'none',
      company: json['company'] ?? 'none',
      dependsOn: json['depends_on'] ?? 'none',
      project: json['project'] ?? 'none',
      progress: json['progress'] ?? 'none',
    );
  }

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

  @override
  List<Object?> get props => [
        name,
        subject,
        project,
        priority,
        status,
        type,
        color,
        expectedStartDate,
        expectedEndDate,
        description,
        department,
        company,
        progress,
        expectedTime,
        dependsOn,
      ];
}
