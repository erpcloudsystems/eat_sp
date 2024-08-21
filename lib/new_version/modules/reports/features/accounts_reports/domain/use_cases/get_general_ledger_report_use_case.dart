import '../../data/models/general_ledger_filter.dart';
import '../entities/general_ledger_report_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../../../core/global/base_use_case.dart';
import '../../../../../../core/network/failure.dart';
import '../repositories/account_report_base_repo.dart';

class GetGeneralLedgerUseCase
    extends BaseUseCase<List<GeneralLedgerReportEntity>, GeneralLedgerFilters> {
  final AccountReportBaseRepo _repo;

  GetGeneralLedgerUseCase(this._repo);

  @override
  Future<Either<Failure, List<GeneralLedgerReportEntity>>> call(
          GeneralLedgerFilters parameters) async =>
      await _repo.getGeneralLedgerReport(parameters);
}
