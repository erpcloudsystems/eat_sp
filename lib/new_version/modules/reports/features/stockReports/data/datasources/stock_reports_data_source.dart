import 'package:NextApp/new_version/core/network/api_constance.dart';
import 'package:NextApp/new_version/core/network/dio_helper.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/data/models/item_price_filters.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/data/models/item_price_report_model.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/data/models/stock_ledger_filter.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/data/models/stock_ledger_report_model.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/data/models/warehouse_report_model.dart';
import 'package:dio/dio.dart';

import '../models/warehouse_filters.dart';

abstract class BaseStockReportDataSource {
  Future<List<WarehouseReportModel>> getWarehouseReports(
      WarehouseFilters filters);

  Future<List<StockLedgerReportModel>> getStockLedgerReports(
      StockLedgerFilters filters);

  Future<List<ItemPriceReportModel>> getItemPriceReports(
      ItemPriceFilters itemPriceFilters);
}

class StockReportDataSourceByDio implements BaseStockReportDataSource {
  final BaseDioHelper _dio;

  const StockReportDataSourceByDio(this._dio);

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

  @override
  Future<List<StockLedgerReportModel>> getStockLedgerReports(
      StockLedgerFilters filters) async {
    final response = await _dio.get(
      endPoint: ApiConstance.getStockLedgerReport,
      query: {
        'warehouse': filters.warehouseFilter,
        'from_date': filters.fromDate,
        'to_date': filters.toDate,
        if (filters.itemCode != null) 'item_code': filters.itemCode,
      },
    ) as Response;

    final _stockLedgerReports = List.from(response.data['message'])
        .map((e) => StockLedgerReportModel.fromJson(e))
        .toList();

    return _stockLedgerReports;
  }

  @override
  Future<List<ItemPriceReportModel>> getItemPriceReports(
      ItemPriceFilters filters) async{
    final response = await _dio.get(
      endPoint: ApiConstance.getItemPriceReport,
      query: {
        if(filters.itemCode != null)'item_code': filters.itemCode,
        if(filters.itemGroup != null)'item_group': filters.itemGroup,
        if(filters.priceList != null)'price_list': filters.priceList,
      }
    ) as Response;

    final _itemPriceReports = List.from(response.data['message'])
        .map((e) => ItemPriceReportModel.fromJson(e))
        .toList();

    return _itemPriceReports;
  }
}
