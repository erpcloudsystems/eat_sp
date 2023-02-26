import 'package:NextApp/new_version/modules/reports/common/GeneralReports/domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  const ReportModel({
    required super.reportName,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        reportName: json['report_name'],
      );

  @override
  List<Object?> get props => [
        reportName,
      ];
}
