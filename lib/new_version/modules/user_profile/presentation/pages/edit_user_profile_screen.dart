import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../bloc/user_profile_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/utils/error_dialog.dart';
import '../widgets/edit_profile_main_screen.dart';
import '../../../../core/utils/request_state.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/snack_bar_util.dart';
import '../widgets/user_profile_generic_app_bar.dart';
import '../../../../core/resources/colors_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../../widgets/dialog/loading_dialog.dart';

class EditUserProfileScreen extends StatelessWidget {
  const EditUserProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final userOldData =
        ModalRoute.of(context)!.settings.arguments as UserEntity;

    return Scaffold(
      backgroundColor: ColorsManager.userProfileScaffoldBackGroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          DoublesManager.d_90.h,
        ),
        child: const UserProfileAppBar(title: StringsManager.editUserProfile),
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listenWhen: (previous, current) =>
            previous.updateUserDataState != current.updateUserDataState,
        listener: (context, state) {
          switch (state.updateUserDataState) {
            case RequestState.stable:
              break;
            case RequestState.loading:
              showLoadingDialog(context, StringsManager.updatingUrData);
              break;
            case RequestState.success:
              SnackBarUtil().getSnackBar(
                context: context,
                message: StringsManager.userDataUpdatedSuccessfully,
                color: Colors.green,
              );
              // We use 2 pops here, one for closing loading dialog and another for navigate to the previous screen.
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              break;
            case RequestState.error:
              showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                        errorMessage: state.updateUserDataMessage,
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ));
          }
        },
        child: EditUserProfileMainScreen(userOldData: userOldData),
      ),
    );
  }
}
