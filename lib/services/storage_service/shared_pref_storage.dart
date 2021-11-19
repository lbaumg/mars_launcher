import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'storage_service.dart';

/*class SharedPreferencesStorage extends StorageService {

  static const time_left_key = 'time_left';
  @override
  Future<int?> getTimeLeft() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(time_left_key);
  }

  @override
  Future<void> saveTimeLeft(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(time_left_key, seconds);
  }

  // Future<void> saveShortcutItems()

}*/

/*
class SharedPreferencesStorage {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}*/
