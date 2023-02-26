import 'package:equatable/equatable.dart';

class DependsOnEntity extends Equatable {
  final String task;
  final String project;
  final String subject;

  DependsOnEntity({
    required this.task,
    required this.project,
    required this.subject,
  });

  @override
  List<Object?> get props => [
        task,
        project,
        subject,
      ];
}
