import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'bloc/server.dart';

class CreateServerPage extends StatefulWidget {
  @override
  _CreateServerPageState createState() => _CreateServerPageState();
}

class _CreateServerPageState extends State<CreateServerPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: "editor.create.title".tr()),
        body: Scrollbar(
            child: Center(
                child: Container(
                    constraints: BoxConstraints(maxWidth: 1000),
                    child: ListView(children: [
                      TextField(
                        decoration: InputDecoration(labelText: "editor.create.name".tr()),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "editor.create.description".tr()),
                      )
                    ])))),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check_outlined),
            onPressed: () => Navigator.of(context).pop(ServerEditorBloc(
                CoursesServer(name: _nameController.text),
                description: _descriptionController.text))));
  }
}
