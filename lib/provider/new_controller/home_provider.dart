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
        'method/ecs_eat.eat_sp.share.share',
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
  Future<List> generalGetList({
    required Map<String, dynamic> filters,
  }) async {
    final response = await service.genericGet(
      'method/ecs_eat.eat_sp.general.general_service',
      filters,
    );
    notifyListeners();

    return response['message'];
  }
}
