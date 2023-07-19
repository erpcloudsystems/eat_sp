import 'dart:io' show Platform;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';
import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../widgets/snack_bar.dart';
import '../widgets/dialog/loading_dialog.dart';

class GPSService {
  GPSService({this.latitude, this.longitude, this.isMocked});
  late LatLng latLang;
  double? latitude;
  double? longitude;
  bool? isMocked;
  List<Placemark> placeman = [];

  Future<LatLng> getCurrentLocation(BuildContext context) async {
    if (!(await Permission.location.request().isGranted)) {
      Geolocator.requestPermission();
    }

    if ((await Permission.location.request().isPermanentlyDenied)) {
      Future.delayed(Duration(seconds: 1), () async {
        final res = await checkDialog(
            context, KPermanentlyDeniedSnackBar, 'Allow Location');
        if (res) {
          AppSettings.openAppSettings();
        }
      });
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      showSnackBar(KLocationGrantedSnackBar, context);

      latitude = position.latitude;
      longitude = position.longitude;
      isMocked = position.isMocked;
      latLang = LatLng(position.latitude, position.longitude);
      try {
        placeman = await placemarkFromCoordinates(latitude!, longitude!);
      } catch (e) {
        print("Fail To get Address from Coordinates.: $e");
      }

      print('latitude:$latitude');
      print('longitude: $longitude');
      print('isMocked:$isMocked');

      if (Platform.isAndroid) {
        if (isMocked == true) {
          showSnackBar('Please use real location', context);
          latitude = 0.0;
          longitude = 0.0;
          latLang = LatLng(0.0, 0.0);
        }

        List<String?> positionCheck = await TrustLocation.getLatLong;
        bool isMockLocation = await TrustLocation.isMockLocation;
        print('isMockLocation Trust Package:$isMockLocation');
      }
    } catch (e) {
      print("Getting location Error: $e");
    }

    return latLang;
  }
}
