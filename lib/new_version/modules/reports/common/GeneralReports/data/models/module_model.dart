import 'package:equatable/equatable.dart';

class ModuleModel extends Equatable {
  final String name, image;

  const ModuleModel({required this.name, required this.image});

  @override
  List<Object?> get props => [
        name,
        image,
      ];
}
