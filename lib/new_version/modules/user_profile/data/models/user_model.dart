import 'dart:convert';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.userName,
    required super.gender,
    required super.birthDate,
    required super.userType,
    required super.lastActive,
    required super.lastLogin,
    required super.roles,
    required super.userImage,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        email: data['email'] ?? 'none',
        firstName: data['first_name'] ?? 'none',
        lastName: data['last_name'] ?? 'none',
        userName: data['username'] ?? 'none',
        gender: data['gender'] ?? 'none',
        birthDate: data['birth_date'] ?? 'none',
        userType: data['user_type'] ?? 'none',
        lastActive: data['last_active'] ?? 'none',
        lastLogin: data['last_login'] ?? 'none',
        roles: List<String>.from(data['roles'] ?? []),
        userImage: data['user_image'] ?? 'none',
      );

  Map<String, dynamic> toMap() => {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'username': userName,
        'gender': gender,
        'birth_date': birthDate,
        'user_type': userType,
        'last_active': lastActive,
        'last_login': lastLogin,
        'roles': List<String>.from(roles),
        'user_image': userImage,
      };

  /// Parses the string and returns the resulting Json object as [UserModel].
  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// Converts [UserModel] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  List<Object> get props {
    return [
      email,
      firstName,
      lastName,
      userName,
      gender,
      birthDate,
      userType,
      lastActive,
      lastLogin,
      roles,
      userImage,
    ];
  }
}
