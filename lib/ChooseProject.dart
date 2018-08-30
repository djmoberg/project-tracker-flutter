import 'dart:async';

import 'package:flutter/material.dart';

import 'package:project_tracker_test/utils.dart';
import 'package:project_tracker_test/ResponseObjects.dart';
import 'package:project_tracker_test/ProjectExplorer.dart';

class ChooseProject extends StatelessWidget {
  final List<Map<String, dynamic>> _projects;
  final VoidCallback _onLogout;
  final VoidCallback _update;

  ChooseProject(this._projects, this._onLogout, this._update);

  @override
  Widget build(BuildContext context) {
    return MyChooseProject(_projects, _onLogout, _update);
  }
}

class MyChooseProject extends StatefulWidget {
  final List<Map<String, dynamic>> _projects;
  final VoidCallback _onLogout;
  final VoidCallback _update;

  MyChooseProject(this._projects, this._onLogout, this._update);

  @override
  _MyChooseProjectState createState() =>
      _MyChooseProjectState(_projects, _onLogout, _update);
}

class _MyChooseProjectState extends State<MyChooseProject> {
  final List<Map<String, dynamic>> _projects;
  final VoidCallback _onLogout;
  final VoidCallback _update;

  _MyChooseProjectState(this._projects, this._onLogout, this._update);

  bool loading = false;

  Future _openProjectExplorer(index) async {
    setState(() {
      loading = true;
    });
    Project project = await getProject(_projects[index]["id"]);
    setState(() {
      loading = false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProjectExplorer(project, _onLogout, _update);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: _projects.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Center(child: Text(_projects[index]["name"])),
                  onTap: () => _openProjectExplorer(index));
            },
          );
  }
}
