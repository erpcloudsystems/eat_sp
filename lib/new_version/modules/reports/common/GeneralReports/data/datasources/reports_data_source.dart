import 'package:NextApp/new_version/core/network/dio_helper.dart';
import 'package:NextApp/new_version/modules/reports/common/GeneralReports/data/models/report_entity.dart';
import 'package:NextApp/new_version/modules/reports/common/GeneralReports/domain/entities/report_entity.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/network/api_constance.dart';

abstract class BaseReportsDataSource {
  Future<List<ReportEntity>> getAllReports(String doctypeName);
}

class ReportsDataSourceByDio implements BaseReportsDataSource {
  final BaseDioHelper _dio;
  const ReportsDataSourceByDio(this._dio);

  @override
  Future<List<ReportEntity>> getAllReports(String moduleName) async {
    final response = await _dio.get(
        endPoint: ApiConstance.getReports,
        query: {'module': moduleName}) as Response;

    final reports = List.from(response.data['message'])
        .map((e) => ReportModel.fromJson(e))
        .toList();
    return reports;
  }
}
