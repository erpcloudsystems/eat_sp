import 'package:NextApp/new_version/modules/new_item/domain/entities/item_group_entity.dart';

class ItemGroupModel extends ItemGroupEntity {
  const ItemGroupModel(
      {required super.name,
      required super.parentItemGroup,
      required super.isGroup,
      required super.previousParent});

  factory ItemGroupModel.fromJson(Map<String, dynamic> json) => ItemGroupModel(
        name: json['name'] ?? 'none',
        parentItemGroup: json['parent_item_group'] ?? 'none',
        isGroup: json['is_group'] ?? 0,
        previousParent: json['previous_parent'] ?? 'none',
      );

  @override
  List<Object?> get props => [
        name,
        parentItemGroup,
        isGroup,
        previousParent,
      ];
}
