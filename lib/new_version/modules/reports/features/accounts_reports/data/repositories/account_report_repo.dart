import 'package:dartz/dartz.dart';
import '../../domain/entities/account_receivable_entity.dart';
import '../models/accounts_receivable_filters.dart';
import '../models/general_ledger_filter.dart';
import '../../../../../../core/network/failure.dart';
import '../../../../../../core/network/exceptions.dart';
import '../data_sources/account_report_data_source.dart';
import '../../../../../../core/network/network_info.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../../domain/repositories/account_report_base_repo.dart';
import '../../domain/entities/general_ledger_report_entity.dart';

class AccountReportsRepo implements AccountReportBaseRepo {
  final BaseNetworkInfo _networkInfo;
  final BaseAccountReportDataSource _accountReportDataSource;

  const AccountReportsRepo(
    this._networkInfo,
    this._accountReportDataSource,
  );

  @override
  Future<Either<Failure, List<GeneralLedgerReportEntity>>>
      getGeneralLedgerReport(GeneralLedgerFilters filters) async {
    if (await _networkInfo.isConnected) {
      try {
        final result =
            await _accountReportDataSource.getGeneralLedgerReports(filters);
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
        OfflineFailure(
          errorMessage: StringsManager.offlineFailureMessage,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<AccountReceivableReportEntity>>>
      getAccountReceivableReport(AccountReceivableFilters filters) async {
    if (await _networkInfo.isConnected) {
      try {
        final result =
            await _accountReportDataSource.getAccountReceivableReport(filters);
        return Right(result);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
          OfflineFailure(errorMessage: StringsManager.offlineFailureMessage));
    }
  }
}
