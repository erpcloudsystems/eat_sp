import 'package:dio/dio.dart';

import '../../../../../../core/network/api_constance.dart';
import '../../../../../../core/network/dio_helper.dart';
import '../models/account_receivable_report_model.dart';
import '../models/accounts_receivable_filters.dart';
import '../models/general_ledger_filter.dart';
import '../models/general_ledger_report_model.dart';

abstract class BaseAccountReportDataSource {
  Future<List<GeneralLedgerModel>> getGeneralLedgerReports(
      GeneralLedgerFilters filters);

  Future<List<AccountReceivableReportModel>> getAccountReceivableReport(
      AccountReceivableFilters filters);
}

class AccountReportDataSourceByDio implements BaseAccountReportDataSource {
  final BaseDioHelper _dio;

  const AccountReportDataSourceByDio(this._dio);

  @override
  Future<List<GeneralLedgerModel>> getGeneralLedgerReports(
      GeneralLedgerFilters filters) async {
    final response = await _dio.get(
      endPoint: ApiConstance.getGeneralLedgerReport,
      query: {
        'page_length': ApiConstance.pageLength,
        'start': filters.startKey,
        'account': filters.account,
        if (filters.fromDate != null) 'from_date': filters.fromDate,
        if (filters.toDate != null) 'to_date': filters.toDate,
        if (filters.partyType != null) 'party_type': filters.partyType,
        if (filters.party != null) 'party': filters.party,
      },
    ) as Response;

    final generalLedgerReport = List.from(response.data['message']['data'])
        .map((e) => GeneralLedgerModel.fromJson(e))
        .toList();

    return generalLedgerReport;
  }

  @override
  Future<List<AccountReceivableReportModel>> getAccountReceivableReport(
      AccountReceivableFilters filters) async {
    final response = await _dio
        .get(endPoint: ApiConstance.getAccountReceivableReport, query: {
      'page_length': ApiConstance.pageLength,
      'start': filters.startKey,
      if (filters.customerCode != null) 'customer_code': filters.customerCode,
      if (filters.customerName != null) 'customer_name': filters.customerName,
      if (filters.salesPersonName != null)
        'sales_person_name': filters.salesPersonName,
      if (filters.toDate != null) 'to_date': filters.toDate,
    }) as Response;

    final accountReceivableReport = List.from(response.data['message'])
        .map((e) => AccountReceivableReportModel.fromJson(e))
        .toList();
    return accountReceivableReport;
  }
}
