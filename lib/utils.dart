import 'dart:async';
import 'dart:convert';

import 'package:project_tracker_test/ResponseObjects.dart';
import 'package:project_tracker_test/Prefs.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const backend = "https://project-tracker-backend.herokuapp.com";
const backend2 = "http://192.168.38.110:3000";

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

Future<int> getWorkTimer() async {
  RWorkTimer timer;
  http.Response response = await http.get(backend + "/workTimer",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    timer = RWorkTimer.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to load timer");
  }
  return timer.startTime;
}

Future setWorkTimer(int startTime) async {
  http.Response response = await http.post(backend + "/workTimer/new",
      headers: {"cookie": await Cookie.getCookie()},
      body: {"startTime": startTime.toString()});
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to set timer");
  }
}

Future deleteWorkTimer() async {
  http.Response response = await http.delete(backend + "/workTimer",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to delete timer");
  }
}

Future addWork(Map<String, dynamic> work) async {
  RAdd res;
  http.Response response = await http.post(backend + "/work/add",
      headers: {
        "cookie": await Cookie.getCookie(),
        "Content-Type": "application/json"
      },
      body: json.encode(work));
  if (response.statusCode == 200) {
    res = RAdd.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to add work");
  }
  return res;
}

Future<bool> userExists(value) async {
  bool res = true;
  http.Response response = await http.get(
    backend + "/user/exists/" + value,
  );
  if (response.statusCode == 200) {
    res = response.body == "true";
  } else {
    throw Exception("Failed to load user exists");
  }
  return res;
}

Future registerUser(Map<String, dynamic> data) async {
  http.Response response = await http.post(backend + "/user/register",
      headers: {"Content-Type": "application/json"}, body: json.encode(data));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to register user");
  }
}

Future sendNewPassword(Map<String, dynamic> data) async {
  http.Response response = await http.post(backend + "/user/sendNewPassword",
      headers: {"Content-Type": "application/json"}, body: json.encode(data));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to send new password");
  }
}

Future registerProject(Map<String, dynamic> data) async {
  http.Response response = await http.post(backend + "/project/register",
      headers: {
        "cookie": await Cookie.getCookie(),
        "Content-Type": "application/json"
      },
      body: json.encode(data));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to register project");
  }
}

Future<List<ProjectSearch>> findProjects(value) async {
  List<ProjectSearch> res = List();
  http.Response response = await http.get(
    backend + "/projects/find/" + value,
    headers: {"cookie": await Cookie.getCookie()},
  );
  if (response.statusCode == 200) {
    List<dynamic> resD = json.decode(response.body);
    resD.forEach((pS) {
      res.add(ProjectSearch.fromJson(pS));
    });
  } else {
    throw Exception("Failed to find projects");
  }
  return res;
}

Future<List<dynamic>> getUsers() async {
  List<dynamic> users;
  http.Response response = await http.get(backend + "/project/users",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    users = json.decode(response.body);
  } else {
    throw Exception("Failed to load projects");
  }
  return users;
}

Future newPassword(Map<String, dynamic> data) async {
  http.Response response = await http.put(backend + "/user/newPassword",
      headers: {
        "cookie": await Cookie.getCookie(),
        "Content-Type": "application/json"
      },
      body: json.encode(data));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to update password");
  }
}
