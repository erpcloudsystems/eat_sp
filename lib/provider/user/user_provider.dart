import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:next_app/service/service.dart';
import '../../core/shared_pref.dart';

class UserProvider extends ChangeNotifier {
  final APIService service = APIService();
  final SharedPref pref = SharedPref();

  String _username = '';

  String get username => _username;

  List<Map<String, dynamic>> _modules = [];

  List<Map<String, dynamic>> get modules => _modules;

  String? _user;

  Map<String,dynamic> _companyDefaults = {};
  String _defaultCurrency = '';

  Map<String,dynamic> get companyDefaults => _companyDefaults;
  String get defaultCurrency => _defaultCurrency;


  List<Map> _defaultTax = [];

  List<Map> get defaultTax => _defaultTax;


  String? get user => _user;

  String? _url;

  String get url => _url ?? '';
  bool _storageAccess = false;
  bool _locationAccess = false;

  bool get storageAccess => _storageAccess;

  List<String>? _showcaseProgress = [];
  List<String>? get showcaseProgress=> _showcaseProgress;


  void setShowcaseProgress(String showcase) async{
    _showcaseProgress!.add(showcase);
    await pref.setShowcaseList(_showcaseProgress!);

    //notifyListeners();
  }


  Future<void> getUserData() async {
    String? user, pass;
    await pref.getPass().then((value) => pass = value);
    await pref.getUserName().then((value) => user = value);
    await pref.getUrl().then((value) => _url = value);
    await pref.getShowcaseList().then((value) => _showcaseProgress = value ?? []);

    if (user != null && pass != null && _url != null)
      await login(user!, pass!, _url!, true);
    else
      _user = null;
  }

  void logout() {
    pref.clearData();
    _user = null;
    _url = null;
    _user = null;
    notifyListeners();
  }

  Future<void> checkPermission() async {
    _storageAccess = await Permission.storage.request().isGranted;

    _locationAccess = !(await Permission.locationAlways.request().isGranted);
    if(_locationAccess){
      Geolocator.requestPermission();
    }

  }

  Future<void> login(String username, String password, String url, bool rememberMe) async {
    if (url.endsWith('/')) url = url.replaceRange(url.length - 1, url.length, '');
    service.changeUrl(url); // to set baseUrl for all app
    final res = await service.login("method/ecs_mobile.api.login", {"usr": username, "pwd": password, 'url': url});

    if (res != null && res['message']['message'] == "Authentication Success") {
      _modules = List<Map<String, dynamic>>.from(res['message']['modules']);
      _username = res['full_name'] ?? 'none';

      try {
        _defaultCurrency = ' (' + res['message']['company_defaults'][0]['default_currency'] + ')';
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

      notifyListeners();
      checkPermission();
    }

  }
}
