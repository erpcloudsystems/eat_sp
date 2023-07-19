part of 'new_item_bloc.dart';

abstract class NewItemEvent extends Equatable {
  const NewItemEvent();

  @override
  List<Object> get props => [];
}

class GetItemEvent extends NewItemEvent {
  final ItemsFilter itemFilter;

  const GetItemEvent({required this.itemFilter});

  @override
  List<Object> get props => [
        itemFilter,
      ];
}

class GetItemGroupEvent extends NewItemEvent {
  final ItemsFilter itemFilter;

  const GetItemGroupEvent({required this.itemFilter});

  @override
  List<Object> get props => [
        itemFilter,
      ];
}

class ResetItemEvent extends NewItemEvent {
  const ResetItemEvent();
}

// class AddItemToListEvent extends NewItemEvent {
//   final Map<String, dynamic> item;

//   const AddItemToListEvent({
//     required this.item,
//   });

//   @override
//   List<Object> get props => [
//         item,
//       ];
// }
