import 'package:equatable/equatable.dart';

class TapViewEntity extends Equatable {
  final String name, title, status;

  const TapViewEntity({
    required this.name,
    required this.title,
    required this.status,
  });

  @override
  List<Object?> get props => [
        name,
        title,
        status,
      ];
}
