import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String email,
      firstName,
      lastName,
      userName,
      gender,
      birthDate,
      userType,
      lastActive,
      lastLogin,
      userImage;

  final List<String> roles;

  const UserEntity({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.gender,
    required this.birthDate,
    required this.userType,
    required this.lastActive,
    required this.lastLogin,
    required this.userImage,
    required this.roles,
  });

  @override
  List<Object?> get props => [
        email,
        firstName,
        lastName,
        userName,
        gender,
        birthDate,
        userType,
        lastActive,
        lastLogin,
        userImage,
        roles,
      ];
}
