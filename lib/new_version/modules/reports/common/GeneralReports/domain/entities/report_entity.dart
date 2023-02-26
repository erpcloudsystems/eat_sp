import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable {
  final String reportName;

  const ReportEntity({
    required this.reportName,
  });

  @override
  List<Object?> get props => [
        reportName,
      ];
}
