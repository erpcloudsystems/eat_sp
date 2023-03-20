import 'package:NextApp/new_version/modules/reports/features/accounts_reports/data/models/general_ledger_filter.dart';
import 'package:NextApp/new_version/modules/reports/features/accounts_reports/data/models/general_ledger_report_model.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/network/api_constance.dart';
import '../../../../../../core/network/dio_helper.dart';

abstract class BaseAccountReportDataSource {
  Future<List<GeneralLedgerModel>> getGeneralLedgerReports(
      GeneralLedgerFilters filters);
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
        'page_length': 10,
        'start': filters.startKey,
        'account': filters.account,
        if (filters.fromDate != null) 'from_date': filters.fromDate,
        if (filters.toDate != null) 'to_date': filters.toDate,
        if (filters.partyType != null) 'party_type': filters.partyType,
        if (filters.party != null) 'party': filters.party,
      },
    ) as Response;

    final _generalLedgerReport = List.from(response.data['message'])
        .map((e) => GeneralLedgerModel.fromJson(e))
        .toList();

    return _generalLedgerReport;
  }
}
