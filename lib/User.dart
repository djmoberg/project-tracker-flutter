import 'package:flutter/material.dart';

import 'package:project_tracker_test/userOptions/Add.dart';
import 'package:project_tracker_test/userOptions/UserOverview.dart';

class User extends StatelessWidget {
  final VoidCallback _updateOverview;

  User(this._updateOverview);

  @override
  Widget build(BuildContext context) {
    return MyUser(_updateOverview);
  }
}

class MyUser extends StatefulWidget {
  final VoidCallback _updateOverview;

  MyUser(this._updateOverview);

  @override
  _MyUserState createState() => _MyUserState(_updateOverview);
}

class _MyUserState extends State<MyUser> {
  final VoidCallback _updateOverview;

  _MyUserState(this._updateOverview);

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _views = [
      Add(_updateOverview),
      UserOverview(),
    ];

    return Scaffold(
      body: _views[_index],
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text("Add"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text("User Overview"),
          ),
        ],
      ),
    );
  }
}
