import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import '../../main.dart';
import '../../service/server_exception.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../service/service.dart';
import '../../core/shared_pref.dart';

class UserProvider extends ChangeNotifier {
  final APIService service = APIService();
  final SharedPref pref = SharedPref();

  String _username = '';
  String _userNotificationToken = '';

  String get username => _username;
  String get userNotificationToken => _userNotificationToken;

  List<Map<String, dynamic>> _modules = [];

  List<Map<String, dynamic>> get modules => _modules;

  String? _user;

  Map<String, dynamic> _companyDefaults = {};
  String _defaultCurrency = '';

  Map<String, dynamic> get companyDefaults => _companyDefaults;
  String get defaultCurrency => _defaultCurrency;

  List<Map> _defaultTax = [];

  List<Map> get defaultTax => _defaultTax;

  String? get user => _user;

  String? _url;
  String? _userId;
  String _platform = 'Android';

  String get url => _url ?? '';
  String get userId => _userId ?? '';

  bool _storageAccess = false;
  bool _locationAccess = false;

  bool get storageAccess => _storageAccess;

  List<String>? _showcaseProgress = [];
  List<String>? get showcaseProgress => _showcaseProgress;

  void setShowcaseProgress(String showcase) async {
    _showcaseProgress!.add(showcase);
    await pref.setShowcaseList(_showcaseProgress!);
  }

  Future<void> getUserData() async {
    String? user, pass;
    await pref.getPass().then((value) => pass = value);
    await pref.getUserName().then((value) => user = value);
    await pref.getUrl().then((value) => _url = value);
    await pref
        .getShowcaseList()
        .then((value) => _showcaseProgress = value ?? []);

    if (user != null && pass != null && _url != null) {
      await login(user!, pass!, _url!, true);
      await APIService().sendNotificationToken(
          deviceTokenToSendPushNotification, _userId.toString(), _platform);
      if (isTokenRefreshed) {
        await APIService().updateNotificationToken(
            deviceTokenToSendPushNotification, _userId.toString(), _platform);
      }
    } else {
      _user = null;
    }
  }

  void logout() async {
    pref.clearData();
    _user = null;
    _url = null;
    notifyListeners();
    await service.logout("method/logout");
  }

  Future<void> checkPermission() async {
    _storageAccess = await Permission.storage.request().isGranted;
    _locationAccess = !(await Permission.locationAlways.request().isGranted);
    if (_locationAccess) {
      Geolocator.requestPermission();
    }
  }

  Future<void> login(
      String username, String password, String url, bool rememberMe) async {
    final bool checkUrlValidation = await service.checkUrlValidation(url);
    if (checkUrlValidation == true) {
      if (url.endsWith('/'))
        url = url.replaceRange(url.length - 1, url.length, '');
      service.changeUrl(url); // to set baseUrl for all app
      final res = await service.login(
          "method/ecs_mobile.api.login", {"usr": username, "pwd": password});

      if (res != null &&
          res['message']['success_key'].toString().toLowerCase() == 'true') {
        _modules = List<Map<String, dynamic>>.from(res['message']['modules']);

        _username = res['full_name'] ?? 'none';
        _userId = res['message']['user_id'] ?? 'none';
        try {
          _defaultCurrency = ' (' +
              res['message']['company_defaults'][0]['default_currency'] +
              ')';
          _companyDefaults = res['message']['company_defaults'][0];
        } catch (e) {
          _defaultCurrency = '-';
          _companyDefaults = {};
        }

        try {
          _defaultTax = List<Map>.from(res['message']['default_tax_template']);
        } catch (e) {
          print(e);
        }

        _user = username;
        _url = url;

        if (rememberMe) {
          await pref.setUserName(username);
          await pref.setPass(password);
          await pref.setUrl(url);
        }

        if (Platform.isAndroid) {
          _platform = "Android";
        } else if (Platform.isIOS) {
          _platform = "Ios";
        }

        notifyListeners();
        checkPermission();
      } else {
        throw ServerException("invalid credentials");
      }
    } else if (checkUrlValidation == false) {
      Fluttertoast.showToast(msg: 'Domain is inactive');
      notifyListeners();
    }
  }
}
