import '../../data/models/accounts_receivable_filters.dart';
import '../../data/models/general_ledger_filter.dart';
import '../entities/account_receivable_entity.dart';
import '../entities/general_ledger_report_entity.dart';
import '../../../../../../core/network/failure.dart';
import 'package:dartz/dartz.dart';

abstract class AccountReportBaseRepo {
  Future<Either<Failure, List<GeneralLedgerReportEntity>>>
      getGeneralLedgerReport(GeneralLedgerFilters filters);
      
  Future<Either<Failure, List<AccountReceivableReportEntity>>>
      getAccountReceivableReport(AccountReceivableFilters filters);
}
