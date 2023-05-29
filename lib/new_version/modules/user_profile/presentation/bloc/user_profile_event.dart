part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class GetUserProfileDataEvent extends UserProfileEvent {
  final String userName;

  const GetUserProfileDataEvent({required this.userName});

  @override
  List<Object> get props => [userName];
}

class UpdateUserProfileDataEvent extends UserProfileEvent {
  final UpdateUserEntity newUserData;

  const UpdateUserProfileDataEvent({required this.newUserData});

  @override
  List<Object> get props => [newUserData];
}
