import 'package:NextApp/new_version/core/network/api_constance.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
        'method/elkhabaz_mobile.share.share',
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
      'method/elkhabaz_mobile.general.general_service',
      filters,
    );
    notifyListeners();

    return response['message'];
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  bool customerLocationLoading = false;
  Future<void> updateCustomerLocation({required String customerName}) async {
    try {
      customerLocationLoading = true;
      notifyListeners();
      Position position = await _determinePosition();
      final res = await service.dio
          .put(ApiConstance.customerLocation, queryParameters: {
        'name': customerName,
        'latitude': position.latitude,
        'longitude': position.longitude
      });
      print(res.data);
      customerLocationLoading = false;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
