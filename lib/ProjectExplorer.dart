import 'package:flutter/material.dart';

import 'package:project_tracker_test/ResponseObjects.dart';
import 'package:project_tracker_test/Admin.dart';
import 'package:project_tracker_test/Overview.dart';
import 'package:project_tracker_test/Settings.dart';
import 'package:project_tracker_test/User.dart';
import 'package:project_tracker_test/WorkTimer.dart';
import 'package:project_tracker_test/Prefs.dart';
import 'package:project_tracker_test/Trash.dart';

class ProjectExplorer extends StatelessWidget {
  final Project _project;
  final VoidCallback _onLogout;
  final VoidCallback _update;

  ProjectExplorer(this._project, this._onLogout, this._update);

  @override
  Widget build(BuildContext context) {
    return MyProjectExplorer(_project, _onLogout, _update);
  }
}

class MyProjectExplorer extends StatefulWidget {
  final Project _project;
  final VoidCallback _onLogout;
  final VoidCallback _update;

  MyProjectExplorer(this._project, this._onLogout, this._update);

  @override
  _MyProjectExplorerState createState() =>
      _MyProjectExplorerState(_project, _onLogout, _update);
}

class _MyProjectExplorerState extends State<MyProjectExplorer> {
  final Project _project;
  final VoidCallback _onLogout;
  final VoidCallback _update;

  _MyProjectExplorerState(this._project, this._onLogout, this._update);

  Widget _route;
  RUser _user = Prefs().user;
  Project _liveProject;

  Widget _getAdminTile() {
    if (_isAdmin()) {
      return ListTile(
        selected: _route.toString() == Admin().toString(),
        leading: Icon(Icons.person_outline),
        title: Text("Admin"),
        onTap: () {
          setState(() {
            _route = Admin();
          });
          Navigator.pop(context);
        },
      );
    }
    return SizedBox();
  }

  bool _isAdmin() {
    if (_user == null) {
      return false;
    } else {
      List<dynamic> isAdminFor = _user.user["isAdmin"];
      return isAdminFor.contains(_liveProject.id);
    }
  }

  void _updateOverview() {
    Project newProject = Project(
        id: _liveProject.id,
        name: _liveProject.name,
        description: _liveProject.description,
        overview: Prefs().overview);
    setState(() {
      _liveProject = newProject;
    });
  }

  @override
  void initState() {
    super.initState();
    _liveProject = _project;
    _route = User(() => _updateOverview(), _liveProject);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.network(
                "https://facelex.com/img/cooltext292638607517631.png",
                height: 100.0,
              ),
              decoration:
                  BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
            ),
            ListTile(
              selected: _route.toString() ==
                  WorkTimer(() => _updateOverview()).toString(),
              leading: Icon(Icons.timer),
              title: Text("Work Timer"),
              onTap: () {
                setState(() {
                  _route = WorkTimer(() => _updateOverview());
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              selected: _route.toString() ==
                  User(() => _updateOverview(), _liveProject).toString(),
              leading: Icon(Icons.account_box),
              title:
                  _user == null ? Text("User") : Text(_user.user["username"]),
              onTap: () {
                setState(() {
                  _route = User(() => _updateOverview(), _liveProject);
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              selected: _route.toString() == Overview(_liveProject).toString(),
              leading: Icon(Icons.calendar_today),
              title: Text("Overview"),
              onTap: () {
                setState(() {
                  _route = Overview(_liveProject);
                });
                Navigator.pop(context);
              },
            ),
            _getAdminTile(),
            ListTile(
              selected: _route.toString() ==
                  Trash(() => _updateOverview()).toString(),
              leading: Icon(Icons.restore_from_trash),
              title: Text("Trash"),
              onTap: () {
                setState(() {
                  _route = Trash(() => _updateOverview());
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text("Change Project"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            Settings(
              _onLogout,
              _update,
              pop: true,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                      title: Center(child: Text(_liveProject.name)),
                      children: <Widget>[
                        Center(child: Text(_liveProject.description))
                      ],
                    ),
              );
            },
            child: Text(_liveProject.name + " - " + _liveProject.description)),
      ),
      body: _route,
    );
  }
}
