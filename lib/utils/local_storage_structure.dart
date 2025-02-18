import 'package:shared_preferences/shared_preferences.dart';

class QuickStorage {
  void storeString({required String key, required String data}) async {
    // Obtain Shared Preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString(key, data);
  }

  void storeBool({required String key, required bool data}) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setBool(key, data);
  }

  void storeDouble({required String key, required double data}) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setDouble(key, data);
  }

  void storeInt({required String key, required int data}) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setInt(key, data);
  }

  void storeListOfString(
      {required String key, required List<String> data}) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setStringList(key, data);
  }

  Future<String> returnString({required String key}) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? action = prefs.getString(key);

    return action ?? '';
  }

  Future<bool> returnBool({required String key}) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool? action = prefs.getBool(key);

    return action ?? false;
  }

  Future<int> returnInt({required String key}) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final int? action = prefs.getInt(key);

    return action ?? 0;
  }

  Future<double> returnDouble({required String key}) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final double? action = prefs.getDouble(key);

    return action ?? 0;
  }

  Future<List<String>> returnListOfStrings({required String key}) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? action = prefs.getStringList(key);

    return action ?? [];
  }
}
