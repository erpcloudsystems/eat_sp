import 'package:NextApp/new_version/modules/reports/features/accounts_reports/data/models/general_ledger_filter.dart';
import 'package:NextApp/new_version/modules/reports/features/accounts_reports/domain/entities/general_ledger_report_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../../../core/network/failure.dart';

abstract class AccountReportBaseRepo {
  Future<Either<Failure, List<GeneralLedgerReportEntity>>> getGeneralLedgerReport(
      GeneralLedgerFilters filters);
}
