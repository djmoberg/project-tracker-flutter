import 'dart:async';

import 'package:flutter/material.dart';

import 'package:project_tracker_test/utils.dart';
import 'package:project_tracker_test/utils2.dart';
import 'package:project_tracker_test/AddDialog.dart';

class WorkTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyWorkTimer();
  }
}

class MyWorkTimer extends StatefulWidget {
  @override
  _MyWorkTimerState createState() => _MyWorkTimerState();
}

class _MyWorkTimerState extends State<MyWorkTimer> {
  int _startTime;
  String _currentTime = "00:00:00";
  Timer _timer;
  int _savedTime;

  _getWorkTimer() async {
    int res = await getWorkTimer();
    setState(() {
      _startTime = res;
    });
    if (res != 0) {
      _startTimer();
    }
  }

  void _updateTime(timer) {
    setState(() {
      _currentTime =
          formatTime(DateTime.now().millisecondsSinceEpoch - _startTime);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 500), _updateTime);
  }

  bool validClockOut() {
    int stopTime = DateTime.now().millisecondsSinceEpoch;
    String hours =
        getHours(formatTimeRounded(_startTime), formatTimeRounded(stopTime));
    if (hours == "0") {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _getWorkTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _startTime == null
          ? CircularProgressIndicator()
          : _startTime == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        "Clock In",
                        style: Theme.of(context).textTheme.display2,
                      ),
                      onPressed: () {
                        int now = DateTime.now().millisecondsSinceEpoch;
                        setState(() {
                          _startTime = now;
                        });
                        _startTimer();
                        setWorkTimer(now);
                      },
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    _savedTime == null
                        ? SizedBox()
                        : RaisedButton(
                            child: Text(
                              "Restore",
                              style: Theme.of(context).textTheme.display2,
                            ),
                            onPressed: () async {
                              setState(() {
                                _startTime = _savedTime;
                              });
                              _startTimer();
                              await setWorkTimer(_savedTime);
                              setState(() {
                                _savedTime = null;
                              });
                            },
                          ),
                  ],
                )
              : ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text("You Started Working"),
                      subtitle: Text(convertDateFull(
                          DateTime.fromMillisecondsSinceEpoch(_startTime))),
                    ),
                    ListTile(
                      leading: Icon(Icons.timer),
                      title: Text("Work Time"),
                      subtitle: Text(_currentTime),
                    ),
                    ListTile(
                      title: RaisedButton(
                        child: Text("Clock Out"),
                        onPressed: () async {
                          int stopTime = DateTime.now().millisecondsSinceEpoch;
                          String hours = getHours(formatTimeRounded(_startTime),
                              formatTimeRounded(stopTime));
                          if (hours == "0.0") {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "You must work for at least 15 minutes!"),
                              ),
                            );
                          } else {
                            bool workAdded = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AddDialog(_startTime, stopTime);
                            }));
                            if (workAdded) {
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text("Work added")));
                              _timer.cancel();
                              setState(() {
                                _startTime = null;
                                _currentTime = "00:00:00";
                              });
                              _getWorkTimer();
                            }
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: RaisedButton(
                        color: Theme.of(context).errorColor,
                        child: Text("Cancel"),
                        onPressed: () async {
                          _timer.cancel();
                          setState(() {
                            _savedTime = _startTime;
                            _startTime = null;
                            _currentTime = "00:00:00";
                          });
                          await deleteWorkTimer();
                          setState(() {
                            _startTime = 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
