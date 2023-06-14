import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/routes.dart';
import 'photo_widget.dart';
import 'user_roles_card.dart';
import 'user_profile_card.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/extensions/date_tine_extension.dart';

class UserProfileMainWidget extends StatelessWidget {
  final UserEntity user;
  const UserProfileMainWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: DoublesManager.d_20),
      child: ListView(
        children: [
          //_________________________User Image and Name______________________
          Column(
            children: [
              UserPhotoWidget(
                radius: DoublesManager.d_40.sp,
                sideWidget: Text(user.userName,
                    style: GoogleFonts.bebasNeue(
                        fontSize: DoublesManager.d_30.sp,
                        fontWeight: FontWeight.bold)),
              ),
              //TODO: Remove with the column in the new UI.
              TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed(Routes.editUserProfileScreen, arguments: user),
                  child: const Text('Update Profile')),
            ],
          ),
          // ________________________________User Email________________________________
          UserProfileCard(
            title: StringsManager.email,
            subtitle: user.email,
            icon: Icons.email_outlined,
          ),

          //________________________________User Full Name_____________________________
          Row(
            children: [
              Expanded(
                child: UserProfileCard(
                  title: StringsManager.firstName,
                  subtitle: user.firstName,
                  icon: Icons.person,
                  leadingPadding: DoublesManager.d_10,
                ),
              ),
              Expanded(
                child: UserProfileCard(
                  title: StringsManager.lastName,
                  leadingPadding: DoublesManager.d_10,
                  subtitle: user.lastName,
                  icon: Icons.person,
                ),
              )
            ],
          ),

          //_____________________________User Type & Gender______________________________
          Row(
            children: [
              Expanded(
                child: UserProfileCard(
                  title: StringsManager.gender,
                  subtitle: user.gender,
                  icon: Icons.groups_rounded,
                  leadingPadding: DoublesManager.d_10,
                ),
              ),
              Expanded(
                child: UserProfileCard(
                  title: StringsManager.userType,
                  leadingPadding: DoublesManager.d_10,
                  subtitle: user.userType,
                  icon: Icons.smart_toy_outlined,
                ),
              )
            ],
          ),

          //______________________________Last Active & Last Login_____________________________
          Row(
            children: [
              Expanded(
                child: UserProfileCard(
                  title: StringsManager.lastActive,
                  subtitle: user.lastActive.formateToReadableDateTime(),
                  icon: Icons.calendar_today,
                  leadingPadding: DoublesManager.d_10,
                ),
              ),
              Expanded(
                child: UserProfileCard(
                  title: StringsManager.lastLogin,
                  leadingPadding: DoublesManager.d_10,
                  subtitle: user.lastLogin.formateToReadableDateTime(),
                  icon: Icons.calendar_today,
                ),
              )
            ],
          ),

          //______________________________Birth Date______________________________
          UserProfileCard(
            title: StringsManager.birthDate,
            subtitle: user.birthDate,
            icon: Icons.cake_outlined,
          ),

          //______________________________User Roles_______________________________
          UserRolesCard(
            rolesList: user.roles,
          ),
        ],
      ),
    );
  }
}
