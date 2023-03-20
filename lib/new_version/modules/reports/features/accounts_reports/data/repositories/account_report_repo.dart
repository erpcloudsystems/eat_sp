import 'package:NextApp/new_version/core/network/failure.dart';
import 'package:NextApp/new_version/modules/reports/features/accounts_reports/data/data_sources/account_report_data_source.dart';
import 'package:NextApp/new_version/modules/reports/features/accounts_reports/data/models/general_ledger_filter.dart';
import 'package:NextApp/new_version/modules/reports/features/accounts_reports/domain/entities/general_ledger_report_entity.dart';
import 'package:NextApp/new_version/modules/reports/features/accounts_reports/domain/repositories/account_report_base_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../../../core/network/exceptions.dart';
import '../../../../../../core/network/network_info.dart';
import '../../../../../../core/resources/strings_manager.dart';

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
          errorMessage: AppStrings.offlineFailureMessage,
        ),
      );
    }
  }
}
