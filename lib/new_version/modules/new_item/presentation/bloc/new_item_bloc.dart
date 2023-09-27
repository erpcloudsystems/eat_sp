import 'dart:async';

import 'package:NextApp/new_version/core/utils/request_state.dart';
import 'package:NextApp/new_version/modules/new_item/domain/usecases/get_item_group_use_case.dart';
import 'package:NextApp/new_version/modules/new_item/domain/usecases/get_items_use_case.dart';
import 'package:NextApp/new_version/modules/new_item/presentation/bloc/new_item_state.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/api_constance.dart';
import '../../data/models/item_filter.dart';

part 'new_item_event.dart';

class NewItemBloc extends Bloc<NewItemEvent, ItemState> {
  final GetItemsUseCase _getItemsUseCase;
  final GetItemsGroupUseCase _getItemsGroupUseCase;
  NewItemBloc(this._getItemsUseCase, this._getItemsGroupUseCase)
      : super(const ItemState()) {
    on<GetItemEvent>(_getItemData, transformer: droppable());
    on<GetItemGroupEvent>(_getItemGroupData, transformer: droppable());
    on<ResetItemEvent>(_resetItemDate);
  }

  FutureOr<void> _getItemData(
      GetItemEvent event, Emitter<ItemState> emit) async {
    if (state.hasReachedMax) return;
    if (state.getItemsState == RequestState.loading ||
        event.itemFilter.searchText != null) {
      final result = await _getItemsUseCase(event.itemFilter);

      result.fold(
          (failure) => emit(
                state.copyWith(
                    getItemsState: RequestState.error,
                    getItemMessage: failure.errorMessage),
              ),
          (itemDate) => emit(state.copyWith(
                getItemsState: RequestState.success,
                getItemData: itemDate,
                hasReachedMax: itemDate.length < ApiConstance.pageLength,
              )));
    } else {
      final result = await _getItemsUseCase(event.itemFilter);
      result.fold(
        (failure) => emit(state.copyWith(
          getItemsState: RequestState.error,
          getItemMessage: failure.errorMessage,
        )),
        (itemDate) => emit(state.copyWith(
          getItemsState: RequestState.success,
          getItemData: List.of(state.getItemData)..addAll(itemDate),
          hasReachedMax: itemDate.length < ApiConstance.pageLength,
        )),
      );
    }
  }

  FutureOr<void> _getItemGroupData(
      GetItemGroupEvent event, Emitter<ItemState> emit) async {
    final result = await _getItemsGroupUseCase(event.itemFilter);
    result.fold(
        (failure) => emit(state.copyWith(
              getItemGroupState: RequestState.error,
              getItemGroupMessage: failure.errorMessage,
            )),
        (itemDate) => emit(state.copyWith(
              getItemGroupState: RequestState.success,
              getItemGroupData: itemDate,
            )));
  }

  FutureOr<void> _resetItemDate(ResetItemEvent event, Emitter<ItemState> emit) {
    print('reserer');
    emit(state.copyWith(
      getItemsState: RequestState.loading,
      getItemData: [],
      hasReachedMax: false,
    ));
  }
}
