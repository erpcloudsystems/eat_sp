import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/resources/strings_manager.dart';
import '../bloc/user_profile_bloc.dart';
import '../../../../../provider/user/user_provider.dart';

class UserPhotoInEditingScreen extends StatefulWidget {
  final Function fileName;
  final Function updatedPhoto64;

  const UserPhotoInEditingScreen({
    super.key,
    required this.fileName,
    required this.updatedPhoto64,
  });

  @override
  State<UserPhotoInEditingScreen> createState() =>
      _UserPhotoInEditingScreenState();
}

class _UserPhotoInEditingScreenState extends State<UserPhotoInEditingScreen> {
  XFile? pickedImage;

  Future<void> pickAnImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    setState(() => pickedImage = image);

    // Giving the name of the image and if it's greater than 140 we make another uuid because Frappe only accept 140 characters.
    final filePath = image!.path;
    widget.fileName(
      filePath.length <= 140 ? filePath : '${const Uuid().v1()}.jpg',
    );

    // Convert the image to Base64 to send it to the Backend.
    final imageBytes = await image.readAsBytes();
    final images64 = base64Encode(imageBytes);
    widget.updatedPhoto64(images64);
  }

  @override
  Widget build(BuildContext context) {
    return UserPhotoWidget(
        radius: DoublesManager.d_30.sp,
        sideWidget: OutlinedButton(
            onPressed: () => pickAnImage(),
            style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(
                    side: BorderSide(
                        color: Colors.grey,
                        width: DoublesManager.d_1,
                        style: BorderStyle.solid))),
            child:  Text(StringsManager.changeUrPhoto.tr())),
        image: pickedImage == null
            ? null
            : FileImage(
                File(pickedImage!.path),
              ));
  }
}

class UserPhotoWidget extends StatelessWidget {
  const UserPhotoWidget({
    super.key,
    required this.sideWidget,
    required this.radius,
    this.image,
  });

  final Widget sideWidget;
  final double radius;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<UserProvider>();
    final bloc = context.watch<UserProfileBloc>();
    final currentUser = bloc.state.userEntity;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage:
              image ?? NetworkImage('${provider.url}${currentUser.userImage}'),
        ),
        sideWidget,
      ],
    );
  }
}
