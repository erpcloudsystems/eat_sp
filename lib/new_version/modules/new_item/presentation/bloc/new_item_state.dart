import 'package:NextApp/new_version/modules/new_item/domain/entities/item_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/request_state.dart';
import '../../domain/entities/item_group_entity.dart';

class ItemState extends Equatable {
  final RequestState getItemsState;
  final RequestState getItemGroupState;
  final String getItemMessage;
  final String getItemGroupMessage;
  final bool hasReachedMax;
  final List<ItemEntity> getItemData;
  final List<ItemGroupEntity> getItemGroupData;

  const ItemState({
    this.getItemsState = RequestState.loading,
    this.getItemGroupState = RequestState.loading,
    this.getItemMessage = '',
    this.getItemGroupMessage = '',
    this.hasReachedMax = false,
    this.getItemData = const [],
    this.getItemGroupData = const [],
    
  });
  ItemState copyWith({
    RequestState? getItemsState,
    RequestState? getItemGroupState,
  
    String? getItemMessage,
    String? getItemGroupMessage,
    List<ItemEntity>? getItemData,
    List<ItemGroupEntity>? getItemGroupData,
    bool? hasReachedMax,
  }) =>
      ItemState(
        getItemsState: getItemsState ?? this.getItemsState,
        getItemGroupState: getItemGroupState ?? this.getItemGroupState,
        getItemMessage: getItemMessage ?? this.getItemMessage,
        getItemGroupMessage: getItemGroupMessage ?? this.getItemGroupMessage,
        getItemData: getItemData ?? this.getItemData,
        getItemGroupData: getItemGroupData ?? this.getItemGroupData,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );
  @override
  List<Object?> get props => [
        getItemsState,
        getItemGroupState,
        getItemMessage,
        getItemData,
        getItemGroupData,
        hasReachedMax,
      ];
}
