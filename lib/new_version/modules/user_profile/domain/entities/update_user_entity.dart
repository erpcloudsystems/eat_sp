import 'package:equatable/equatable.dart';

class UpdateUserEntity extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? gender;
  final String? filename;
  final String? imageContent;

  const UpdateUserEntity({
    this.firstName,
    this.lastName,
    this.birthDate,
    this.gender,
    this.filename,
    this.imageContent,
  });

  @override
  String toString() {
    return 'UpdateUserEntity(firstName: $firstName, lastName: $lastName, birthDate: $birthDate, gender: $gender, filename: $filename, imageContent: $imageContent)';
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        birthDate,
        gender,
        filename,
        imageContent,
      ];
}
