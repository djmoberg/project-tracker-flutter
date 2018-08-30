import 'package:flutter/material.dart';

import 'package:project_tracker_test/userOptions/Add.dart';
import 'package:project_tracker_test/userOptions/UserOverview.dart';

class User extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyUser();
  }
}

class MyUser extends StatefulWidget {
  @override
  _MyUserState createState() => _MyUserState();
}

class _MyUserState extends State<MyUser> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _views = [
      Add(),
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
