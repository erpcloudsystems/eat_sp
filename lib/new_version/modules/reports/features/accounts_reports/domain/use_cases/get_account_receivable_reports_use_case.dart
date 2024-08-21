import '../../../../../../core/global/base_use_case.dart';
import '../../../../../../core/network/failure.dart';
import '../../data/models/accounts_receivable_filters.dart';
import '../entities/account_receivable_entity.dart';
import '../repositories/account_report_base_repo.dart';
import 'package:dartz/dartz.dart';

class GetAccountReceivableReportsUseCase extends BaseUseCase<
    List<AccountReceivableReportEntity>, AccountReceivableFilters> {
  final AccountReportBaseRepo repo;
  GetAccountReceivableReportsUseCase(this.repo);

  @override
  Future<Either<Failure, List<AccountReceivableReportEntity>>> call(
      AccountReceivableFilters parameters) async => 
  await repo.getAccountReceivableReport(parameters);
}
