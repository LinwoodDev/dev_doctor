import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CreateServerPage extends StatefulWidget {
  const CreateServerPage({Key? key}) : super(key: key);

  @override
  _CreateServerPageState createState() => _CreateServerPageState();
}

class _CreateServerPageState extends State<CreateServerPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Box<ServerEditorBloc> _box = Hive.box<ServerEditorBloc>('editor');
  @override
  Widget build(BuildContext context) {
    var names = _box.values.map((e) => e.server.name);
    return Scaffold(
        appBar: MyAppBar(title: "editor.create.title".tr()),
        body: Form(
            key: _formKey,
            child: Scrollbar(
                child: Center(
                    child: Container(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: ListView(children: [
                          TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "editor.create.name.empty".tr();
                                }
                                if (names.contains(value)) {
                                  return "editor.create.name.exist".tr();
                                }
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
            tooltip: "editor.create.submit".tr(),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _box.add(ServerEditorBloc(
                    name: _nameController.text, note: _noteController.text));
                Navigator.of(context).pop();
              }
            },
            child: const Icon(PhosphorIcons.checkLight)));
  }
}
