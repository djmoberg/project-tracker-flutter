class Projects {
  final List<Map<String, dynamic>> projects;

  Projects({this.projects});

  factory Projects.fromJson(List<dynamic> json) {
    return Projects(
      projects: List<Map<String, dynamic>>.from(json),
    );
  }
}

class Project {
  final int id;
  final String name;
  final String description;
  final List<dynamic> overview;

  Project({this.id, this.name, this.description, this.overview});

  factory Project.fromJson(id, Map<String, dynamic> json) {
    return Project(
        id: id,
        name: json["name"],
        description: json["description"],
        overview: json["overview"]);
  }
}

class RUser {
  bool loggedIn;
  Map<String, dynamic> user;

  RUser({this.loggedIn, this.user});

  factory RUser.fromJson(Map<String, dynamic> json) {
    return RUser(loggedIn: json["loggedIn"], user: json["user"]);
  }
}
