import 'package:dartz/dartz.dart';

import '../datasources/faq_data_sourcs.dart';
import '../../domain/entities/faq_entity.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/faq_base_repo.dart';
import '../../../../core/resources/strings_manager.dart';

class FaqImplementationRepo implements FaqBaseRepo {
  final FaqBaseDataSource _dataSource;
  final BaseNetworkInfo _networkInfo;

  const FaqImplementationRepo(this._dataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<Faq>>> getFaqs({String? tag}) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _dataSource.getFaq(tag);
        return Right(response);
      } on PrimaryServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message));
      }
    } else {
      return const Left(
          OfflineFailure(errorMessage: StringsManager.offlineFailureMessage));
    }
  }
}
