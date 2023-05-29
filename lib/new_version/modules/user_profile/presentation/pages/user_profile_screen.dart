import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../bloc/user_profile_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/resources/routes.dart';
import '../../../../core/utils/error_dialog.dart';
import '../widgets/user_profile_main_widget.dart';
import '../../../../core/utils/request_state.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../../widgets/custom_loading.dart';
import '../widgets/user_profile_generic_app_bar.dart';
import '../../../../core/resources/colors_manager.dart';
import '../../../../core/resources/strings_manager.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late UserEntity currentUserData;

    return Scaffold(
      backgroundColor: ColorsManager.userProfileScaffoldBackGroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            DoublesManager.d_90.h,
          ),
          child: UserProfileAppBar(
            title: StringsManager.userProfile,
            actionIcon: IconButton(
                onPressed: () => Navigator.of(context).pushNamed(
                    Routes.editUserProfileScreen,
                    arguments: currentUserData),
                icon: const Icon(Icons.edit_square, size: DoublesManager.d_30)),
          )),
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
          listenWhen: (previous, current) =>
              previous.getUserDataState != current.getUserDataState,
          listener: (context, state) {
            if (state.getUserDataState == RequestState.error) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      ErrorDialog(errorMessage: state.getUserDataMessage));
            }
          },
          buildWhen: (previous, current) =>
              previous.userEntity != current.userEntity ||
              previous.getUserDataState != current.getUserDataState,
          builder: (context, state) {
            if (state.getUserDataState == RequestState.success) {
              currentUserData = state.userEntity;
              return UserProfileMainWidget(user: state.userEntity);
            } else if (state.getUserDataState == RequestState.loading) {
              return const CustomLoadingWithImage();
            }
            return const SizedBox();
          }),
    );
  }
}
