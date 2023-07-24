import 'dart:async';

import 'package:NextApp/new_version/modules/dashboard/domain/entities/counter_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/utils/request_state.dart';
import '../../../data/models/get_total_sales_invoice_filters.dart';
import '../../../domain/use_cases/get_total.dart';

part 'total_event.dart';

part 'total_state.dart';

class TotalBloc extends Bloc<TotalEvent, TotalState> {
  final GetTotalUseCase _getTotalUseCase;

  TotalBloc(this._getTotalUseCase,)
      : super(const TotalState()) {
    on<GetTotalEvent>(_getTotalSalesInvoice);
  }

  FutureOr<void> _getTotalSalesInvoice(
      GetTotalEvent event, Emitter<TotalState> emit) async {

      final result =
      await _getTotalUseCase(event.totalSalesInvoiceFilters);

      result.fold(
            (failure) => emit(state.copyWith(
              getTotalState: RequestState.error,
          getDashboardMessage: failure.errorMessage,
        )),
            (totalList) => emit(
          state.copyWith(
            getTotalState: RequestState.success,
            totalEntity: totalList,
          ),
        ),
      );

  }

}
