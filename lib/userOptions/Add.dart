import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: <Widget>[
        RaisedButton(
          child: Text(convertDate(_date)),
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
        RaisedButton(
          onPressed: () {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: 1, minute: 1),
            );
          },
        ),
      ],
    );
  }
}
