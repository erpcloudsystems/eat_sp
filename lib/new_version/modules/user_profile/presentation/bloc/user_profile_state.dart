part of 'user_profile_bloc.dart';

class UserProfileState extends Equatable {
  // Get User Profile Data
  final RequestState getUserDataState;
  final UserEntity userEntity;
  final String getUserDataMessage;

  // Update User Profile Data
  final RequestState updateUserDataState;
  final String updateUserDataMessage;

  const UserProfileState({
    // Get User Data
    this.getUserDataState = RequestState.loading,
    this.userEntity = const UserEntity(
        email: '',
        firstName: '',
        lastName: '',
        userName: '',
        gender: '',
        birthDate: '',
        userType: '',
        lastActive: '',
        lastLogin: '',
        userImage: '',
        roles: []),
    this.getUserDataMessage = '',

    // Update User Data
    this.updateUserDataState = RequestState.stable,
    this.updateUserDataMessage = '',
  });

  UserProfileState copyWith({
    // Get User Data
    RequestState? getUserDataState,
    UserEntity? userEntity,
    String? getUserDataMessage,

    // Update User Data
    RequestState? updateUserDataState,
    String? updateUserDataMessage,
  }) =>
      UserProfileState(
        // Get User Data
        getUserDataState: getUserDataState ?? this.getUserDataState,
        userEntity: userEntity ?? this.userEntity,
        getUserDataMessage: getUserDataMessage ?? this.getUserDataMessage,

        // Update User Data
        updateUserDataState: updateUserDataState ?? this.updateUserDataState,
        updateUserDataMessage:
            updateUserDataMessage ?? this.updateUserDataMessage,
      );
  @override
  List<Object> get props => [
        // Get User Data
        getUserDataState,
        userEntity,
        getUserDataMessage,

        // Update User Data
        updateUserDataState,
        updateUserDataMessage,
      ];
}
