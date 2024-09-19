import 'dart:io' show Platform;
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'service.dart';
import 'service_constants.dart';
import '../core/constants.dart';
import '../widgets/snack_bar.dart';
import '../widgets/dialog/loading_dialog.dart';
import '../new_version/core/utils/error_dialog.dart';
import '../new_version/core/resources/app_values.dart';
import '../new_version/core/resources/strings_manager.dart';
import '../new_version/core/extensions/date_time_extension.dart';

class GPSService {
  GPSService({this.latitude, this.longitude, this.isMocked});
  late LatLng latLang;
  double? latitude;
  double? longitude;
  bool? isMocked;
  List<Placemark> placeman = [];

  Future<LatLng> getCurrentLocation(BuildContext context) async {
    if (!(await Permission.location.isGranted)) {
      Geolocator.requestPermission();
    }

    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.deniedForever) {
      Future.delayed(const Duration(seconds: 1), () async {
        final res = await checkDialog(
            context, KPermanentlyDeniedSnackBar, 'Allow Location');
        if (res!) {
          AppSettings.openAppSettings();
        }
      });
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      latitude = position.latitude;
      longitude = position.longitude;
      isMocked = position.isMocked;
      latLang = LatLng(position.latitude, position.longitude);
      try {
        placeman = await placemarkFromCoordinates(latitude!, longitude!);
      } catch (e) {
        debugPrint("Fail To get Address from Coordinates.: $e");
      }

      debugPrint('latitude:$latitude');
      debugPrint('longitude: $longitude');
      debugPrint('isMocked:$isMocked');

      if (Platform.isAndroid) {
        if (isMocked == true) {
          showSnackBar('Please use real location', context);
          latitude = 0.0;
          longitude = 0.0;
          latLang = const LatLng(0.0, 0.0);
        }
      }
    } catch (e) {
      debugPrint("Getting location Error: $e");
    }

    return latLang;
  }

  /// This configurations is related to background tracking.
  static void trackUserLocation(BuildContext context) async {
    await Permission.locationAlways.isGranted.then((value) async {
      if (!value) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            errorMessage: StringsManager.userPermissionForLocationMessage.tr(),
            onPressed: () async {
              Navigator.of(context).pop();
              await Permission.location.request();
              await Permission.locationAlways.request();
            },
          ),
        );
      }
    });
    const distanceFilter = IntManager.i_100;
    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: distanceFilter,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: StringsManager.locationNotificationTitle,
            notificationTitle: StringsManager.locationNotificationText,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: distanceFilter,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      );
    }

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
      final server = APIService();
      if (position != null) {
        await handleRequest(
            () async => await server.postRequest(Location_tacking, {
                  // We send it in this way as requested by the backend [Kholoud El-Barody].
                  'long': position.latitude,
                  'lat': position.longitude,
                  'date': position.timestamp.formatDateYMD(),
                }),
            context);
      }
    });
  }
}
