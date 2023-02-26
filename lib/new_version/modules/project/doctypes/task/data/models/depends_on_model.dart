import '../../domain/entities/depends_on_entity.dart';

class DependsOnModel extends DependsOnEntity {
  DependsOnModel({
    required super.task,
    required super.project,
    required super.subject,
  });
  factory DependsOnModel.fromJson(Map<String, dynamic> json) => DependsOnModel(
        task: json['task'] ?? '',
        project: json['project'] ?? '',
        subject: json['subject'] ?? '',
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task'] = this.task;
    data['project'] = this.project;
    data['subject'] = this.subject;
    return data;
  }

  @override
  List<Object?> get props => [
        task,
        project,
        subject,
      ];
}
