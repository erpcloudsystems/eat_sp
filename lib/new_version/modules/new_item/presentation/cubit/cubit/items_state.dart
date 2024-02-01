part of 'items_cubit.dart';

abstract class ItemsState {}

class ItemsInitial extends ItemsState {}

class GetAllItemsSuccessfullyState extends ItemsState {
  final List<dynamic> items;

  GetAllItemsSuccessfullyState(this.items);
}

class GettingAllItemsFailedState extends ItemsState {
  final String failMsg;

  GettingAllItemsFailedState(this.failMsg);
}

class GettingItemsLoadingState extends ItemsState {}
