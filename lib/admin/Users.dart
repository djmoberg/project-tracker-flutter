import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : _users.length == 0
            ? Text("No users")
            : Column(
                children: _userWidgets(),
              );
  }
}

class UserOptionDialog extends StatelessWidget {
  final Map<String, dynamic> _user;

  UserOptionDialog(this._user);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Options: " + _user["name"]),
      children: <Widget>[
        !_user["isAdmin"]
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FlatButton(
                    child: Text("Make Admin"),
                    color: Theme.of(context).buttonColor,
                    onPressed: () => Navigator.pop(context, "admin")),
              )
            : SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FlatButton(
              child: Text("Remove"),
              color: Colors.red,
              onPressed: () => Navigator.pop(context, "remove")),
        ),
      ],
    );
  }
}
