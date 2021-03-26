import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';

class CreateServerPage extends StatefulWidget {
  @override
  _CreateServerPageState createState() => _CreateServerPageState();
}

class _CreateServerPageState extends State<CreateServerPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  Box<ServerEditorBloc> _box = Hive.box<ServerEditorBloc>('editor');
  @override
  Widget build(BuildContext context) {
    var _names = _box.values.map((e) => e.server.name);
    return Scaffold(
        appBar: MyAppBar(title: "editor.create.title".tr()),
        body: Form(
            key: _formKey,
            child: Scrollbar(
                child: Center(
                    child: Container(
                        constraints: BoxConstraints(maxWidth: 1000),
                        child: ListView(children: [
                          TextFormField(
                              validator: (value) {
                                if (value.isEmpty) return "editor.create.name.empty".tr();
                                if (_names.contains(value)) return "editor.create.name.exist".tr();
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: "editor.create.name.label".tr(),
                                  hintText: "editor.create.name.hint".tr()),
                              controller: _nameController),
                          TextFormField(
                              decoration: InputDecoration(
                                  labelText: "editor.create.note.label".tr(),
                                  hintText: "editor.create.note.hint".tr()),
                              controller: _noteController)
                        ]))))),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check_outlined),
            tooltip: "editor.create.submit".tr(),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _box.add(ServerEditorBloc(name: _nameController.text, note: _noteController.text));
                Navigator.of(context).pop();
              }
            }));
  }
}
