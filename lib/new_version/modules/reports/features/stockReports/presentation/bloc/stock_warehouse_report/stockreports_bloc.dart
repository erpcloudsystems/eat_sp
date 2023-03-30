import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/network/api_constance.dart';
import '../../../../../../../core/utils/request_state.dart';
import '../../../data/models/warehouse_filters.dart';
import '../../../domain/entities/warehouse_report_entity.dart';
import '../../../domain/usecases/get_warehouse_reports_use_case.dart';

part 'stockreports_event.dart';
part 'stockreports_state.dart';

class StockReportsBloc extends Bloc<StockReportsEvent, StockReportsState> {
  final GetWarehouseReportsUseCase _warehouseReportsUseCase;

  StockReportsBloc(this._warehouseReportsUseCase) : super(StockReportsState()) {
    on<GetWarehouseEvent>(_getWarehouseReports, transformer: droppable());
    on<ResetWarehouseEvent>(_resetWarehouseReports);
  }

  FutureOr<void> _getWarehouseReports(
      GetWarehouseEvent event, Emitter<StockReportsState> emit) async {
    if (state.hasReachedMax) return;

    if (state.getWarehouseReportsState == RequestState.loading) {
      final result = await _warehouseReportsUseCase(event.warehouseFilters);

      result.fold(
          (failure) => emit(state.copyWith(
                getWarehouseReportsState: RequestState.error,
                getWarehouseReportMessage: failure.errorMessage,
              )),
          (warehouseReports) => emit(state.copyWith(
                getWarehouseReportsState: RequestState.success,
                getWarehouseReportData: warehouseReports,
                hasReachedMax: warehouseReports.length < ApiConstance.pageLength,
              )));
    } else {
      final result = await _warehouseReportsUseCase(WarehouseFilters(
        warehouseFilter: event.warehouseFilters.warehouseFilter,
        itemFilter: event.warehouseFilters.itemFilter,
        startKey: state.getWarehouseReportData.length + 1,
      ));
      result.fold(
        (failure) => emit(state.copyWith(
          getWarehouseReportsState: RequestState.error,
          getWarehouseReportMessage: failure.errorMessage,
        )),
        (warehouseReports) => emit(
          state.copyWith(
            getWarehouseReportsState: RequestState.success,
            getWarehouseReportData: List.of(state.getWarehouseReportData)
              ..addAll(warehouseReports),
            hasReachedMax: warehouseReports.length < ApiConstance.pageLength,
          ),
        ),
      );
    }
  }

  FutureOr<void> _resetWarehouseReports(
      ResetWarehouseEvent event, Emitter<StockReportsState> emit) {
    emit(state.copyWith(
      getWarehouseReportsState: RequestState.loading,
      getWarehouseReportData: [],
      hasReachedMax: false,
    ));
  }
}
