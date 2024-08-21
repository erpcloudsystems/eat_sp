import 'package:dio/dio.dart';

import '../../../../../../core/network/api_constance.dart';
import '../../../../../../core/network/dio_helper.dart';
import '../models/warehouse_filters.dart';
import '../models/warehouse_report_model.dart';

abstract class BaseWarehouseDataSource {
  Future<List<WarehouseReportModel>> getWarehouseReports(
      WarehouseFilters filters);
}

class WarehouseDataSourceByDio implements BaseWarehouseDataSource {
  final BaseDioHelper _dio;
  const WarehouseDataSourceByDio(this._dio);

  @override
  Future<List<WarehouseReportModel>> getWarehouseReports(
      WarehouseFilters filters) async {
    final response =
        await _dio.get(endPoint: ApiConstance.getWarehouseReports, query: {
      'page_length': 10,
      'start': filters.startKey,
      'warehouse_filter': filters.warehouseFilter,
      if (filters.itemFilter != null) 'item_filter': filters.itemFilter,
    }) as Response;

    final _warehouseReports = List.from(response.data['message'])
        .map((e) => WarehouseReportModel.fromJson(e))
        .toList();

    return _warehouseReports;
  }
}
