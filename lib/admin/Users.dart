import 'package:flutter/material.dart';
import 'package:project_tracker_test/admin/UserOptionDialog.dart';

import 'package:project_tracker_test/utils.dart';
import 'package:project_tracker_test/Prefs.dart';

class Users extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyUsers();
  }
}

class MyUsers extends StatefulWidget {
  @override
  _MyUsersState createState() => _MyUsersState();
}

class _MyUsersState extends State<MyUsers> {
  List<dynamic> _users = List();
  bool _loading = false;
  List<dynamic> _requests;
  bool _loadingRequests = false;

  _getUsers() async {
    setState(() {
      _loading = true;
    });
    List<dynamic> res = await getUsers();
    res.removeWhere((user) {
      return user["name"] == Prefs().user.user["username"];
    });
    setState(() {
      _users = res;
      _loading = false;
    });
  }

  _makeAdmin(username) async {
    setState(() {
      _loading = true;
    });
    await makeAdmin({"username": username});
    await _getUsers();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(username + " is now an admin of the project"),
    ));
  }

  _removeUser(username) async {
    setState(() {
      _loading = true;
    });
    await removeUser(username);
    await _getUsers();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(username + " was removed from the project"),
    ));
  }

  List<Widget> _userWidgets() {
    List<Widget> widgets = List();

    _users.forEach((user) {
      widgets.add(
        ListTile(
          title: Row(
            children: <Widget>[
              Expanded(child: Text(user["name"])),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              String res = await showDialog(
                  context: context,
                  builder: (context) => UserOptionDialog(user));
              switch (res) {
                case "admin":
                  _makeAdmin(user["name"]);
                  break;
                case "remove":
                  _removeUser(user["name"]);
                  break;
                default:
              }
            },
          ),
        ),
      );
    });

    return widgets;
  }

  //joinRequests

  _getJoinRequests() async {
    setState(() {
      _loadingRequests = true;
    });
    List<dynamic> res = await getJoinRequests();
    setState(() {
      _requests = res;
      _loadingRequests = false;
    });
  }

  _deleteProjectJoinRequest(userId, username) async {
    setState(() {
      _loadingRequests = true;
    });
    await deleteProjectJoinRequest(userId);
    await _getJoinRequests();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(username + " was rejected from the project"),
    ));
  }

  _addUser(username, userId) async {
    setState(() {
      _loadingRequests = true;
    });
    await addUser({"username": username});
    await deleteProjectJoinRequest(userId);
    await _getJoinRequests();
    await _getUsers();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(username + " was added to the project"),
    ));
  }

  List<Widget> _joinWidgets() {
    List<Widget> widgets = List();

    _requests.forEach((request) {
      widgets.add(
        ListTile(
          title: Row(
            children: <Widget>[
              Expanded(child: Text(request["name"])),
              IconButton(
                icon: Icon(Icons.clear),
                color: Colors.red,
                onPressed: () =>
                    _deleteProjectJoinRequest(request["id"], request["name"]),
              ),
              IconButton(
                icon: Icon(Icons.check),
                color: Colors.green,
                onPressed: () {
                  _addUser(request["name"], request["id"]);
                },
              ),
            ],
          ),
        ),
      );
    });

    return widgets;
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
    _getJoinRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "Users In The Project",
          style: Theme.of(context).textTheme.subhead,
        ),
        _loading
            ? Center(child: CircularProgressIndicator())
            : _users.length == 0
                ? Text("No users")
                : Column(
                    children: _userWidgets(),
                  ),
        Divider(),
        Text(
          "Requests To Join The Project",
          style: Theme.of(context).textTheme.subhead,
        ),
        _loadingRequests
            ? Center(child: CircularProgressIndicator())
            : _requests.length == 0
                ? Text("No requests")
                : Column(
                    children: _joinWidgets(),
                  ),
      ],
    );
  }
}
