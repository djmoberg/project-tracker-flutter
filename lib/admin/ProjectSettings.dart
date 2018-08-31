import 'package:flutter/material.dart';

class ProjectSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyProjectSettings();
  }
}

class MyProjectSettings extends StatefulWidget {
  @override
  _MyProjectSettingsState createState() => _MyProjectSettingsState();
}

class _MyProjectSettingsState extends State<MyProjectSettings> {
  String _name = "";
  String _description = "";
  bool _loading = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool _validForm() {
    return _name != "";
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              RaisedButton(
                child: Text("Save"),
                onPressed: !_validForm()
                    ? null
                    : () async {
                        setState(() {
                          _loading = true;
                        });
                        // await registerProject(
                        //     {"description": _description, "name": _name});
                        setState(() {
                          _loading = false;
                          _name = "";
                          _description = "";
                        });
                        _nameController.clear();
                        _descriptionController.clear();
                        // _updateProjects();
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Project Registered")));
                      },
              ),
            ],
          );
  }
}
