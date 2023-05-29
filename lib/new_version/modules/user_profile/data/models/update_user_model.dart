import '../../domain/entities/update_user_entity.dart';

class UpdateUserModel extends UpdateUserEntity {
  const UpdateUserModel({
    super.firstName,
    super.lastName,
    super.birthDate,
    super.gender,
    super.filename,
    super.imageContent,
  });

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'birth_date': birthDate,
        'gender': gender,
        if (filename != null) 'filename': filename,
        if (imageContent != null) 'image_content': imageContent,
      };

}
