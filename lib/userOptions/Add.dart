import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:project_tracker_test/utils.dart';
import 'package:project_tracker_test/utils2.dart';

class Add extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyAdd();
  }
}

class MyAdd extends StatefulWidget {
  @override
  _MyAddState createState() => _MyAddState();
}

class _MyAddState extends State<MyAdd> {
  DateTime _date = DateTime.now();
  int fromH = DateTime.now().hour;
  int fromM = 0;
  int toH = DateTime.now().hour;
  int toM = 15;
  String _comment = "";
  bool _loading = false;
  TextEditingController _controller;

  bool _validForm() {
    return _comment != "";
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: <Widget>[
        Center(
          child: Text(
            "Date",
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        FlatButton(
          child: Text(
            convertDate(_date),
            style: Theme.of(context).textTheme.display1,
          ),
          onPressed: () async {
            DateTime date = await showDatePicker(
                context: context,
                firstDate: DateTime(DateTime.now().year),
                initialDate: _date,
                lastDate: DateTime.now());

            if (date != null) {
              setState(() {
                _date = date;
              });
            }
          },
        ),
        SizedBox(
          height: 16.0,
        ),
        Center(
          child: Text(
            "From",
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text(
                withZero(fromH),
                style: Theme.of(context).textTheme.display1,
              ),
              onPressed: () {
                showModalBottomSheet(
                    builder: (context) {
                      return CupertinoPicker(
                        looping: true,
                        backgroundColor: Theme.of(context).bottomAppBarColor,
                        children: new List<Widget>.generate(24, (int index) {
                          return new Center(
                            child: new Text(
                              withZero(index),
                              style: Theme.of(context).textTheme.title,
                            ),
                          );
                        }),
                        itemExtent: 50.0,
                        onSelectedItemChanged: (int value) {
                          setState(() {
                            fromH = value;
                          });
                        },
                      );
                    },
                    context: context);
              },
            ),
            Text(
              ":",
              style: Theme.of(context).textTheme.display1,
            ),
            FlatButton(
              child: Text(
                withZero(fromM),
                style: Theme.of(context).textTheme.display1,
              ),
              onPressed: () {
                showModalBottomSheet(
                    builder: (context) {
                      return CupertinoPicker(
                        looping: true,
                        backgroundColor: Theme.of(context).bottomAppBarColor,
                        children: <Widget>[
                          Center(
                            child: new Text(
                              "00",
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                          Center(
                            child: new Text(
                              "15",
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                          Center(
                            child: new Text(
                              "30",
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                          Center(
                            child: new Text(
                              "45",
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                        ],
                        itemExtent: 50.0,
                        onSelectedItemChanged: (int value) {
                          setState(() {
                            fromM = value == 1
                                ? 15
                                : value == 2 ? 30 : value == 3 ? 45 : value;
                          });
                        },
                      );
                    },
                    context: context);
              },
            ),
          ],
        ),
        SizedBox(
          height: 16.0,
        ),
        Center(
          child: Text(
            "To",
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text(
                withZero(toH),
                style: Theme.of(context).textTheme.display1,
              ),
              onPressed: () {
                showModalBottomSheet(
                    builder: (context) {
                      return CupertinoPicker(
                        looping: true,
                        backgroundColor: Theme.of(context).bottomAppBarColor,
                        children: new List<Widget>.generate(24, (int index) {
                          return new Center(
                            child: new Text(
                              withZero(index),
                              style: Theme.of(context).textTheme.title,
                            ),
                          );
                        }),
                        itemExtent: 50.0,
                        onSelectedItemChanged: (int value) {
                          setState(() {
                            toH = value;
                          });
                        },
                      );
                    },
                    context: context);
              },
            ),
            Text(
              ":",
              style: Theme.of(context).textTheme.display1,
            ),
            FlatButton(
              child: Text(
                withZero(toM),
                style: Theme.of(context).textTheme.display1,
              ),
              onPressed: () {
                showModalBottomSheet(
                    builder: (context) {
                      return CupertinoPicker(
                        looping: true,
                        backgroundColor: Theme.of(context).bottomAppBarColor,
                        children: <Widget>[
                          Center(
                            child: new Text(
                              "00",
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                          Center(
                            child: new Text(
                              "15",
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                          Center(
                            child: new Text(
                              "30",
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                          Center(
                            child: new Text(
                              "45",
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                        ],
                        itemExtent: 50.0,
                        onSelectedItemChanged: (int value) {
                          setState(() {
                            toM = value == 1
                                ? 15
                                : value == 2 ? 30 : value == 3 ? 45 : value;
                          });
                        },
                      );
                    },
                    context: context);
              },
            ),
          ],
        ),
        SizedBox(
          height: 16.0,
        ),
        Center(
          child: Text(
            "Comment",
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        TextField(
          maxLines: 5,
          controller: _controller,
          onChanged: (value) {
            setState(() {
              _comment = value;
            });
          },
        ),
        SizedBox(
          height: 16.0,
        ),
        RaisedButton(
          child: Text("Add"),
          onPressed: !_validForm() || _loading
              ? null
              : () async {
                  setState(() {
                    _loading = true;
                  });
                  await addWork({
                    "addedUsers": [],
                    "comment": _comment,
                    "workDate": convertDateBackend(_date),
                    "workFrom": "${withZero(fromH)}:${withZero(fromM)}",
                    "workTo": "${withZero(toH)}:${withZero(toM)}"
                  });
                  setState(() {
                    _date = DateTime.now();
                    fromH = DateTime.now().hour;
                    fromM = 0;
                    toH = DateTime.now().hour;
                    toM = 15;
                    _comment = "";
                    _loading = false;
                  });
                  _controller.clear();
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("Work added")));
                },
        ),
      ],
    );
  }
}
