import 'dart:async';

import 'package:NextApp/new_version/core/utils/request_state.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/entities/dashboard_entity.dart';
import 'package:NextApp/new_version/modules/dashboard/domain/entities/sealse_invoice_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/models/get_total_sales_invoice_filters.dart';
import '../../domain/use_cases/get_dashboard_data_use_case.dart';

part 'dasboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase _dashboardUseCase;

  DashboardBloc(
    this._dashboardUseCase,
  ) : super(const DashboardState()) {
    on<GetDashboardDataEvent>(_getDashboardData);
  }

  FutureOr<void> _getDashboardData(
      GetDashboardDataEvent event, Emitter<DashboardState> emit) async {
    // if (state.getDashboardState == RequestState.loading) {
    final result = await _dashboardUseCase(event.dateFilter);

    result.fold(
      (failure) => emit(state.copyWith(
        getDashboardState: RequestState.error,
        getDashboardMessage: failure.errorMessage,
      )),
      (dashboardData) => emit(
        state.copyWith(
          getDashboardState: RequestState.success,
          dashboardEntity: dashboardData,
        ),
      ),
    );
    // }
  }
}
