import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_profile_text_field.dart';
import 'package:flutter/material.dart';
import 'photo_widget.dart';

import 'gender_radio.dart';
import 'birth_date_field.dart';
import '../bloc/user_profile_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/resources/app_values.dart';
import '../../domain/entities/update_user_entity.dart';
import '../../../../core/resources/strings_manager.dart';

class EditUserProfileMainScreen extends StatelessWidget {
  final UserEntity userOldData;
  const EditUserProfileMainScreen({super.key, required this.userOldData});

  @override
  Widget build(BuildContext context) {
    final firstNameController =
        TextEditingController(text: userOldData.firstName);
    final lastNameController =
        TextEditingController(text: userOldData.lastName);
    final formKey = GlobalKey<FormState>();
    String? updatedBirthDate;
    String? updatedGender;
    String? fileName;
    String? photoIn64;

    void saveFunction() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        final newUserData = UpdateUserEntity(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          gender: updatedGender ?? userOldData.gender,
          birthDate: updatedBirthDate ?? userOldData.birthDate,
          // filename: fileName,
          imageContent: photoIn64,
        );

        BlocProvider.of<UserProfileBloc>(context)
            .add(UpdateUserProfileDataEvent(newUserData: newUserData));
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DoublesManager.d_20.w),
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            //_________________________User Photo______________________
            UserPhotoInEditingScreen(
              fileName: (String newFileName) => fileName = newFileName,
              updatedPhoto64: (String pickedImage) => photoIn64 = pickedImage,
            ),
            const SizedBox(height: DoublesManager.d_20),
            //_________________________First Name______________________
            UserProfileTextField(
              controller: firstNameController,
              fieldName: StringsManager.firstName,
            ),
            const SizedBox(height: DoublesManager.d_20),
            //__________________________Last Name______________________
            UserProfileTextField(
              controller: lastNameController,
              fieldName: StringsManager.lastName,
            ),
            const SizedBox(height: DoublesManager.d_20),
            //_______________________Birth Date________________________
            BirthDateField(
                userBirthDate: userOldData.birthDate,
                newBirthDate: (String newBirthDate) =>
                    updatedBirthDate = newBirthDate),
            const SizedBox(height: DoublesManager.d_20),
            //_______________________Gender____________________________
            GenderRadio(
              userGender: userOldData.gender,
              newGender: (String newGender) => updatedGender = newGender,
            ),
            const SizedBox(height: DoublesManager.d_20),
            //_______________________Save Button________________________
            NewCustomButton(
              function: saveFunction,
              title: StringsManager.save,
            ),
          ],
        ),
      ),
    );
  }
}
