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

  List<Widget> _userWidgets() {
    List<Widget> widgets = List();

    _users.forEach((user) {
      widgets.add(ListTile(
          title: Row(
        children: <Widget>[
          Expanded(child: Text(user["name"])),
          DropdownButton(
            items: <DropdownMenuItem>[
              DropdownMenuItem(
                child: Text("Options"),
              ),
              DropdownMenuItem(
                child: Text("Make admin"),
              ),
              DropdownMenuItem(
                child: Text("Remove"),
              ),
            ],
            onChanged: (value) {},
          ),
          // RaisedButton(
          //   child: Text("Make admin"),
          //   onPressed: () {},
          // ),
          // RaisedButton(
          //   child: Text("Remove"),
          //   onPressed: () {},
          // ),
        ],
      )));
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
