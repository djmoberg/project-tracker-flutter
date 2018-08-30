import 'dart:async';

import 'package:flutter/material.dart';

import 'package:project_tracker_test/ResponseObjects.dart';
import 'package:project_tracker_test/utils.dart';

class JoinProject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyJoinProject();
  }
}

class MyJoinProject extends StatefulWidget {
  @override
  _MyJoinProjectState createState() => _MyJoinProjectState();
}

class _MyJoinProjectState extends State<MyJoinProject> {
  List<ProjectSearch> _results = List();
  bool _loading = false;
  String _searchValue = "";

  Future _search(value) async {
    List<ProjectSearch> res = await findProjects(value);
    setState(() {
      _results = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (value) async {
              setState(() {
                _searchValue = value;
              });
              if (value != "") {
                setState(() {
                  _loading = true;
                });
                await _search(value);
                setState(() {
                  _loading = false;
                });
              } else {
                setState(() {
                  _results = List();
                });
              }
            },
            decoration: InputDecoration(suffixIcon: Icon(Icons.search)),
          ),
          _loading
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 16.0,
                    ),
                    CircularProgressIndicator()
                  ],
                )
              : _results.length == 0 && _searchValue != ""
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 16.0,
                        ),
                        Text("No Results")
                      ],
                    )
                  : _searchValue == ""
                      ? SizedBox()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              ProjectSearch res = _results[index];
                              return ListTile(
                                title: Text(res.name),
                                subtitle: Text(res.description),
                                trailing: RaisedButton(
                                  child: Text("Send"),
                                  onPressed: () {},
                                ),
                              );
                            },
                          ),
                        ),
        ],
      ),
    );
  }
}
