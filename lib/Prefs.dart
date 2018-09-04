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
  int selectedProject;
  List<dynamic> overview;

  Future init() async {
    user = await _getUser();
    theme = await _getTheme();
    selectedProject = await _getSelectedProject();
  }

  static Future<RUser> _getUser() async {
    String userString = await _prefs.then((prefs) {
      return (prefs.getString("user") ?? null);
    });
    return userString == null ? null : RUser.fromJson(json.decode(userString));
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

  static Future<int> _getSelectedProject() async {
    int selectedProject = await _prefs.then((prefs) {
      return (prefs.getInt("selectedProject") ?? null);
    });
    return selectedProject;
  }

  Future setSelectedProject(value) async {
    await _prefs.then((prefs) {
      prefs.setInt("selectedProject", value);
    });
    selectedProject = value;
  }

  //Non persistence

  void setOverview(value) async {
    overview = value;
  }
}
