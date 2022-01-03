import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  Future<String> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    // print(json.decode(prefs.getString(key)!));
    return json.decode(prefs.getString(key)!);
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
