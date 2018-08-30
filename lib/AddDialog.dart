import 'package:flutter/material.dart';

import 'package:project_tracker_test/utils.dart';
import 'package:project_tracker_test/utils2.dart';

class AddDialog extends StatelessWidget {
  final int _startTime;
  final int _stopTime;

  AddDialog(this._startTime, this._stopTime);

  @override
  Widget build(BuildContext context) {
    return MyAddDialog(_startTime, _stopTime);
  }
}

class MyAddDialog extends StatefulWidget {
  final int _startTime;
  final int _stopTime;

  MyAddDialog(this._startTime, this._stopTime);

  @override
  _MyAddDialogState createState() =>
      _MyAddDialogState(this._startTime, this._stopTime);
}

class _MyAddDialogState extends State<MyAddDialog> {
  final int _startTime;
  final int _stopTime;

  _MyAddDialogState(this._startTime, this._stopTime);

  String _comment = "";
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clock Out"),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                ListTile(
                  leading: Text("Date"),
                  title: Text(convertDate(
                      DateTime.fromMillisecondsSinceEpoch(_startTime))),
                ),
                ListTile(
                  leading: Text("From"),
                  title: Text(formatTimeRounded(_startTime)),
                ),
                ListTile(
                  leading: Text("To"),
                  title: Text(formatTimeRounded(_stopTime)),
                ),
                ListTile(
                  leading: Text("Hours"),
                  title: Text(getHours(formatTimeRounded(_startTime),
                      formatTimeRounded(_stopTime))),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _comment = value;
                    });
                  },
                  // autofocus: true,
                  maxLines: 5,
                  decoration: InputDecoration(labelText: "Comment"),
                ),
                SizedBox(
                  height: 32.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    RaisedButton(
                      child: Text("Save"),
                      onPressed: _comment.length == 0
                          ? null
                          : () async {
                              setState(() {
                                _loading = true;
                              });
                              await addWork({
                                "addedUsers": [],
                                "comment": _comment,
                                "workDate": convertDateBackend(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        _startTime)),
                                "workFrom": formatTimeRounded(_startTime),
                                "workTo": formatTimeRounded(_stopTime)
                              });
                              await deleteWorkTimer();
                              Navigator.pop(context, true);
                            },
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
