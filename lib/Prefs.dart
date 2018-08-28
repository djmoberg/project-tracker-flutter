import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_tracker_test/ResponseObjects.dart';

class Prefs {
  static final Prefs _singleton = new Prefs._internal();
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  factory Prefs() {
    return _singleton;
  }

  Prefs._internal();

  RUser user;
  String theme = "dark";

  Future init() async {
    user = await _getUser();
    theme = await _getTheme();
  }

  static Future<RUser> _getUser() async {
    String userString = await _prefs.then((prefs) {
      return (prefs.getString("user") ?? "");
    });
    return RUser.fromJson(json.decode(userString));
  }

  Future setUser(value) async {
    await _prefs.then((prefs) {
      prefs.setString("user", value);
    });
    user = RUser.fromJson(json.decode(value));
  }

  static Future<String> _getTheme() async {
    String theme = await _prefs.then((prefs) {
      return (prefs.getString("theme") ?? "light");
    });
    return theme;
  }

  Future setTheme(value) async {
    await _prefs.then((prefs) {
      prefs.setString("theme", value);
    });
    theme = value;
  }
}
