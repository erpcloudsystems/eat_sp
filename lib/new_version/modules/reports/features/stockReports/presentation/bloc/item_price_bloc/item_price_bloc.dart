import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../../../../../core/network/api_constance.dart';
import '../../../../../../../core/utils/request_state.dart';
import '../../../data/models/item_price_filters.dart';
import '../../../domain/usecases/get_item_price_report_use_case.dart';
import 'item_price_state.dart';

part 'item_price_event.dart';

class ItemPriceBloc extends Bloc<ItemPriceEvent, ItemPriceState> {
  final GetItemPriceUseCase _getItemPriceUseCase;

  ItemPriceBloc(this._getItemPriceUseCase) : super(ItemPriceState()) {
    on<GetItemPriceEvent>(_getItemPriceReport, transformer: droppable());
    on<ResetItemPriceEvent>(_resetItemPriceReports);
  }

  FutureOr<void> _getItemPriceReport(
      GetItemPriceEvent event, Emitter<ItemPriceState> emit) async{
    if (state.hasReachedMax) return;
    if (state.getItemPriceReportsState == RequestState.loading) {
      final result = await _getItemPriceUseCase(event.itemPriceFilters);
      result.fold(
              (failure) => emit(state.copyWith(
            getItemPriceReportsState: RequestState.error,
            getItemPriceReportMessage: failure.errorMessage,
          )),
              (stockLedgerReport) => emit(state.copyWith(
            getItemPriceReportsState: RequestState.success,
            getItemPriceReportData: stockLedgerReport,
            hasReachedMax: false,
          )));
    }else{
      final result = await _getItemPriceUseCase(ItemPriceFilters(
        priceList: event.itemPriceFilters.priceList,
        itemCode: event.itemPriceFilters.itemCode,
        itemGroup: event.itemPriceFilters.itemGroup,
        startKey: state.getItemPriceReportData.length + 1,
      ));
      result.fold(
            (failure) => emit(state.copyWith(
          getItemPriceReportsState: RequestState.error,
          getItemPriceReportMessage: failure.errorMessage,
        )),
            (itemPriceReport) => emit(
          state.copyWith(
            getItemPriceReportsState: RequestState.success,
            getItemPriceReportData: List.of(state.getItemPriceReportData)
              ..addAll(itemPriceReport),
            hasReachedMax: itemPriceReport.length < ApiConstance.pageLength,
          ),
        ),
      );
    }
  }

  FutureOr<void> _resetItemPriceReports(
      ResetItemPriceEvent event, Emitter<ItemPriceState> emit) {
    emit(state.copyWith(
      getItemPriceReportsState: RequestState.loading,
      getItemPriceReportData: [],
      hasReachedMax: false,
    ));
  }
}
