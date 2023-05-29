import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';
import '../../../../core/utils/request_state.dart';
import '../../domain/entities/update_user_entity.dart';
import '../../domain/usecases/get_user_profile_data_use_case.dart';
import '../../domain/usecases/update_user_profile_data_use_case.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfileDataUseCase _profileDataUseCase;
  final UpdateUserProfileDataUseCase _updateUserProfileDataUseCase;

  UserProfileBloc(this._profileDataUseCase, this._updateUserProfileDataUseCase)
      : super(const UserProfileState()) {
    on<GetUserProfileDataEvent>(_getUserProfileData);
    on<UpdateUserProfileDataEvent>(_updateUserProfileData);
  }

  FutureOr<void> _getUserProfileData(
      GetUserProfileDataEvent event, Emitter<UserProfileState> emit) async {
    final response = await _profileDataUseCase(event.userName);

    response.fold(
      (failure) => emit(state.copyWith(
        getUserDataState: RequestState.error,
        getUserDataMessage: failure.errorMessage,
      )),
      (userProfileData) => emit(state.copyWith(
        getUserDataState: RequestState.success,
        userEntity: userProfileData,
      )),
    );
  }

  FutureOr<void> _updateUserProfileData(
      UpdateUserProfileDataEvent event, Emitter<UserProfileState> emit) async {
    emit(state.copyWith(updateUserDataState: RequestState.loading));

    final response = await _updateUserProfileDataUseCase(event.newUserData);

    response.fold(
      (failure) => emit(state.copyWith(
        updateUserDataState: RequestState.error,
        updateUserDataMessage: failure.errorMessage,
      )),
      (newUserData) => emit(state.copyWith(
        updateUserDataState: RequestState.success,
        userEntity: newUserData,
      )),
    );
  }
}
