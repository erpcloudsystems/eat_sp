import 'package:equatable/equatable.dart';

class ItemGroupEntity extends Equatable {
  final String name, parentItemGroup ,previousParent;
  final int isGroup;
  const ItemGroupEntity({
    required this.name,
    required this.parentItemGroup,
    required this.isGroup,
    required this.previousParent
  });

  @override
  List<Object?> get props => [
        name,
        parentItemGroup,
        isGroup,
      ];
}
