// import 'package:NextApp/new_version/core/global/base_use_case.dart';
// import 'package:NextApp/new_version/core/network/failure.dart';
// import 'package:NextApp/new_version/modules/dashboard/data/models/get_total_sales_invoice_filters.dart';
// import 'package:NextApp/new_version/modules/dashboard/data/models/transaction_filters.dart';
// import 'package:NextApp/new_version/modules/dashboard/domain/entities/counter_entity.dart';
// import 'package:NextApp/new_version/modules/dashboard/domain/entities/sealse_invoice_entity.dart';
// import 'package:NextApp/new_version/modules/dashboard/domain/repositories/dashboard_base_repo.dart';
// import 'package:dartz/dartz.dart';
//
// import '../entities/transaction_entity.dart';
//
// class GetTotalCustomerVisitUseCase
//     extends BaseUseCase<CounterEntity, TotalFilters> {
//   final DashboardBaseRepo _dashboardBaseRepo;
//
//   GetTotalCustomerVisitUseCase(this._dashboardBaseRepo);
//
//   @override
//   Future<Either<Failure, CounterEntity>> call(
//       TotalFilters parameters) async =>
//       await _dashboardBaseRepo.getCustomerVisitCount(parameters);
// }
