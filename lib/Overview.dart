import 'package:flutter/material.dart';

import 'package:project_tracker_test/ResponseObjects.dart';
import 'package:project_tracker_test/utils2.dart';

class Overview extends StatelessWidget {
  final Project _project;

  Overview(this._project);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Hours total: " + getTotalHours(_project.overview)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _project.overview.length,
            itemBuilder: (context, index) {
              var data = _project.overview[index];
              return Card(
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(data["name"]),
                      Text(data["workDate"]),
                      Text("${data["workFrom"]} - ${data["workTo"]}"),
                      Text(getHours(data["workFrom"], data["workTo"])),
                    ],
                  ),
                  subtitle: Text(data["comment"]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
