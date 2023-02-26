import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future clearData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user");
    await prefs.remove("pass");
    await prefs.remove("url");
  }

  Future setUserName(String user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user", user);
  }

  Future setPass(String pass) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("pass", pass);
  }

  Future setUrl(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("url", url);
  }

  Future setShowcaseList(List<String> showcase) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("showcase", showcase);
  }

  Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString("user");
    return user;
  }

  Future<String?> getPass() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var pass = prefs.getString("pass");
    return pass;
  }

  Future<String?> getUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = prefs.getString("url");
    return url;
  }

  Future<List<String>?> getShowcaseList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var showcase = prefs.getStringList("showcase");
    return showcase;
  }
}
