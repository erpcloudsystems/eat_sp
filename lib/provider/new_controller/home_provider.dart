import 'package:NextApp/service/local_notification_service.dart';
import 'package:flutter/material.dart';

import '../../service/service.dart';

class HomeProvider extends ChangeNotifier {
  final APIService service = APIService();

  Future<void> sharedDoc({
    required Map<String, dynamic> data,
    String? errorMessage,
  }) async {
    try {
      print(data);
      final response = await service.genericGet(
        'method/ecs_mobile.share.share',
        {
          "share_doctype": data['docType'],
          "share_name": data['docId'],
          "user": data['user'],
          "read": data['read'],
          "write": data['write'],
          "submit": data['submit'],
          "share": data['share'],
        },
      );
      if (response['message'] != null) {
        return response['message'];
      }
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  /// General get list
  List<Map<String, dynamic>> getList = [];
  Future<void> generalGetList(
      {required String docType}) async {
    final response = await service.genericGet(
      'method/ecs_mobile.general.general_service',
      {'docType': docType},
    );
    getList = response['message'];
    notifyListeners();
  }
}
