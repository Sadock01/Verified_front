import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static late SharedPreferences _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static setLimit(double limit) async {
    if (_prefs == null) return;
    await _prefs!.setDouble("spending_limit", limit);
  }

  static Future<void> setFirstTimeFlag(bool isFirstTime) async {
    await _prefs.setBool('isFirstTime', isFirstTime);
  }

  static double getLimit() {
    return _prefs?.getDouble("spending_limit") ?? 500.0;
  }

  static bool isFirstTime() {
    return _prefs.getBool('isFirstTime') ?? true;
  }

  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // Example of getting a string value
  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static void setCaissierNameAndNum(String firstname, String lastname) {
    _prefs.setString("firstname", firstname);
    _prefs.setString("lastname", lastname);
  }

  static String? getfirstnameCaissier() {
    return _prefs.getString("firstname");
  }

  static String? getlastnameCaissier() {
    return _prefs.getString("lastname");
  }

  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
