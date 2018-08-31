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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DropdownButton(
              items: <DropdownMenuItem>[
                DropdownMenuItem(
                  child: Text("All"),
                ),
                DropdownMenuItem(
                  child: Text("Daniel"),
                ),
                DropdownMenuItem(
                  child: Text("Frank"),
                ),
              ],
              onChanged: (value) {},
            ),
            DropdownButton(
              items: <DropdownMenuItem>[
                DropdownMenuItem(
                  child: Text("All"),
                ),
                DropdownMenuItem(
                  child: Text("January"),
                ),
                DropdownMenuItem(
                  child: Text("February"),
                ),
              ],
              onChanged: (value) {},
            ),
            DropdownButton(
              items: <DropdownMenuItem>[
                DropdownMenuItem(
                  child: Text("All"),
                ),
                DropdownMenuItem(
                  child: Text("2018"),
                ),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _project.overview.length,
            itemBuilder: (context, index) {
              var data = _project.overview[index];
              String name = data["name"];
              String workDate = data["workDate"];
              String time = "${data["workFrom"]} - ${data["workTo"]}";
              String hours = getHours(data["workFrom"], data["workTo"]);
              String comment = data["comment"];
              return Card(
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(workDate),
                          Text(time),
                          Text(hours),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Text(comment),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
