import 'package:flutter/material.dart';

import 'package:project_tracker_test/admin/Users.dart';
// import 'package:project_tracker_test/admin/AddUser.dart';
// import 'package:project_tracker_test/admin/JoinRequests.dart';
import 'package:project_tracker_test/admin/ProjectSettings.dart';
import 'package:project_tracker_test/admin/ProjectDelete.dart';
import 'package:project_tracker_test/ResponseObjects.dart';

class Admin extends StatelessWidget {
  final Project _project;
  final VoidCallback _updateProject;

  Admin(this._project, this._updateProject);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: <Widget>[
        // Text(
        //   "Users In The Project",
        //   style: Theme.of(context).textTheme.subhead,
        // ),
        Users(),
        // Divider(),
        // Text(
        //   "Add User",
        //   style: Theme.of(context).textTheme.subhead,
        // ),
        // AddUser(),
        // Divider(),
        // Text(
        //   "Requests To Join The Project",
        //   style: Theme.of(context).textTheme.subhead,
        // ),
        // JoinRequests(),
        Divider(),
        Text(
          "Project Settings",
          style: Theme.of(context).textTheme.subhead,
        ),
        ProjectSettings(_project, _updateProject),
        Divider(),
        Text(
          "Delete Project",
          style: Theme.of(context).textTheme.subhead,
        ),
        ProjectDelete(),
      ],
    );
  }
}
