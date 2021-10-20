import 'package:shared_preferences/shared_preferences.dart';

// Shared Preferences
final String sName = "SharedPrefsName";
final String sMobile = "SharedPrefsMobile";
final String sUid = "SharedPrefsUid";
final String sEmail = "SharedPrefsEmail";

class SharedPrefsRepo {
  setMyString(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
