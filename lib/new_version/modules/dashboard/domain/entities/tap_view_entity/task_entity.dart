import 'package:equatable/equatable.dart';

class TapViewEntity extends Equatable {
  final String name, title, status, subtitle;
  final String? type;
  const TapViewEntity(
      {required this.name,
      required this.title,
      required this.status,
      required this.subtitle,
      this.type});

  @override
  List<Object?> get props => [
        name,
        title,
        status,
        subtitle,
        type,
      ];
}
