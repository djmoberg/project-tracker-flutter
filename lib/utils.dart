import 'dart:async';
import 'dart:convert';

import 'package:project_tracker_test/ResponseObjects.dart';
import 'package:project_tracker_test/Prefs.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const backend = "https://project-tracker-backend.herokuapp.com";

class Cookie {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<String> getCookie() async {
    String cookie = await _prefs.then((prefs) {
      return (prefs.getString("cookie") ?? "");
    });
    return cookie;
  }

  static Future setCookie(value) async {
    await _prefs.then((prefs) {
      prefs.setString("cookie", value);
    });
  }
}

Future<bool> loggedIn() async {
  bool loggedIn;

  http.Response response = await http.get(backend + "/authenticate/loggedIn",
      headers: {"cookie": await Cookie.getCookie()});

  if (response.statusCode == 200) {
    Map<String, dynamic> body = json.decode(response.body);
    loggedIn = body["loggedIn"];
    Prefs().setUser(response.body);
  } else {
    throw Exception("Failed to load loggedIn");
  }

  return loggedIn;
}

Future login(username, password) async {
  http.Response response = await http.post(backend + "/authenticate/login",
      body: {"username": username, "password": password});
  if (response.statusCode == 200) {
    await Cookie.setCookie(response.headers["set-cookie"]);
    bool li = await loggedIn();
    print(li);
  } else {
    throw Exception("Failed to load login");
  }
}

Future logout() async {
  http.Response response = await http.get(backend + "/authenticate/logout",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    await Cookie.setCookie(response.headers["set-cookie"]);
  } else {
    throw Exception("Failed to load login");
  }
}

Future<List<Map<String, dynamic>>> getProjects() async {
  Projects projects;
  http.Response response = await http.get(backend + "/projects",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    projects = Projects.fromJson(json.decode(response.body));
    // print(projects.projects);
  } else {
    throw Exception("Failed to load projects");
  }
  return projects.projects;
}

Future<Project> getProject(int id) async {
  Project project;
  http.Response response = await http.get(backend + "/project/" + id.toString(),
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    project = Project.fromJson(id, json.decode(response.body));
    print(project.id);
  } else {
    throw Exception("Failed to load projects");
  }
  return project;
}
