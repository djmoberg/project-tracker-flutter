import 'dart:async';

import 'package:flutter/material.dart';

import 'package:project_tracker_test/utils.dart';
import 'package:project_tracker_test/ResponseObjects.dart';
import 'package:project_tracker_test/ProjectExplorer.dart';
import 'package:project_tracker_test/Prefs.dart';

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
  List<Map<String, dynamic>> _liveProjects;

  Future _openProjectExplorer(id) async {
    setState(() {
      loading = true;
    });
    Project project = await getProject(id);
    await Prefs().setSelectedProject(id);
    Prefs().setProjectName(project.name);
    setState(() {
      loading = false;
    });
    bool remove =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProjectExplorer(project, _onLogout, _update);
    }));
    Prefs().setSelectedProject(null);
    if (remove != null && remove) {
      setState(() {
        _liveProjects.removeWhere((pro) => pro["id"] == id);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    int selectedProject = Prefs().selectedProject;
    if (selectedProject != null) {
      _openProjectExplorer(selectedProject);
    }
    _liveProjects = _projects;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: _liveProjects.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Center(child: Text(_liveProjects[index]["name"])),
                  onTap: () =>
                      _openProjectExplorer(_liveProjects[index]["id"]));
            },
          );
  }
}
