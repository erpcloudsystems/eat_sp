import 'package:dio/dio.dart';

import '../models/update_user_model.dart';
import '../models/user_model.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/api_constance.dart';

abstract class BaseUserProfileDataSource {
  Future<UserModel> getUserProfileDataSource(String userName);
  Future<UserModel> updateUserProfileDataSource(UpdateUserModel newUserData);
}

class UserDataSourceByDio implements BaseUserProfileDataSource {
  final BaseDioHelper _dio;
  const UserDataSourceByDio(this._dio);

  @override
  Future<UserModel> getUserProfileDataSource(String userName) async {
    final response = await _dio.get(
        endPoint: ApiConstance.getUserProfileData,
        query: {'name': userName}) as Response;

    final userProfile = UserModel.fromMap(response.data['message']);

    return userProfile;
  }

  @override
  Future<UserModel> updateUserProfileDataSource(UpdateUserModel newUserData) async {
    final userOldData = newUserData.toJson();

    final response = await _dio.patch(
      endPoint: ApiConstance.updateUserProfileData,
      data: userOldData,
    ) as Response;

    final userNewData = UserModel.fromMap(response.data['message']);

    return userNewData;
  }
}
