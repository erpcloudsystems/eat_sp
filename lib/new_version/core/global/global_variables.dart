class GlobalVariables {
  static final GlobalVariables _globalVariables = GlobalVariables._internal();

  String _baseUrl = '';
  var _cookiesForNewVersion;

  factory GlobalVariables() => _globalVariables;

  GlobalVariables._internal();

  String get getBaseUrl => _baseUrl;
  dynamic get cookiesForNewVersion => _cookiesForNewVersion;
  set setBaseUrl(String baseUrl) => _baseUrl = baseUrl;
  set setCookiesForNewVersion(var cookiesForNewVersion) =>
      _cookiesForNewVersion = cookiesForNewVersion;
}
