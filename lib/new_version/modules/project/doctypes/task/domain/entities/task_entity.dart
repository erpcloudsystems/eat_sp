import 'package:equatable/equatable.dart';

import 'depends_on_entity.dart';

class TaskEntity extends Equatable {
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
  final List<DependsOnEntity> dependsOn;
  final DateTime expectedStartDate, expectedEndDate;

  TaskEntity({
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
