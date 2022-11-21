import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:next_app/core/constants.dart';
import 'package:next_app/widgets/snack_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:app_settings/app_settings.dart';

import '../widgets/dialog/loading_dialog.dart';

class GPSService{

  GPSService({ this.latitude, this.longitude,this.isMocked});
  late LatLng latLang;
  double? latitude ;
  double? longitude;
  bool? isMocked;
  List<Placemark> placemarks=[];

  Future<LatLng> getCurrentLocation(BuildContext context) async{
   //Geolocator.requestPermission();


    if(!(await Permission.location.request().isGranted)){
      Geolocator.requestPermission();
    }


   if((await Permission.location.request().isPermanentlyDenied)){
     //AppSettings.openLocationSettings();
     Future.delayed(Duration(seconds: 1), () async{
       final res = await checkDialog(
           context,
           KPermanentlyDeniedSnackBar,
           'Allow Location'
       )  ;
       if(res){
         AppSettings.openAppSettings();
       }
     });
   }

    try{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      showSnackBar(KLocationGrantedSnackBar, context);

      latitude =  position.latitude ;
      longitude = position.longitude;
      isMocked = position.isMocked;
      latLang = LatLng(position.latitude,position.longitude);
      try{
         placemarks = await placemarkFromCoordinates(latitude!, longitude!);

      }catch(e){
        print("Fail To get Address from Coordinates.: $e");
      }

      print('latitude:$latitude');
      print('longitude: $longitude');
      print('isMocked:$isMocked');

      if(isMocked == true){
        showSnackBar(
            'Please use real location',
            context)  ;
        latitude =  0.0 ;
        longitude = 0.0;
        latLang = LatLng(0.0,0.0);

      }

      List<String?> positionCheck = await TrustLocation.getLatLong;
      bool isMockLocation = await TrustLocation.isMockLocation;
      print('isMockLocation Trust Package:$isMockLocation');



    } catch (e) {
      print("Getting location Error: $e");
    }

    return latLang;


  }


}

