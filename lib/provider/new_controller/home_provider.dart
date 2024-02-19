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
  Future<List> generalGetList({required String docType, String? search}) async {
    final response = await service.genericGet(
      'method/ecs_mobile.general.general_service',
      {
        'doctype': docType,
        'page_length': 20,
        if (search != null) 'search_text': search,
      },
    );
    notifyListeners();

    return response['message'];
  }
}
