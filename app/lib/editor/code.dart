import 'dart:convert';

import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EditorCodeDialogPage extends StatefulWidget {
  final String initialValue;

  const EditorCodeDialogPage({Key? key, required this.initialValue})
      : super(key: key);

  @override
  _EditorCodeDialogPageState createState() => _EditorCodeDialogPageState();
}

class _EditorCodeDialogPageState extends State<EditorCodeDialogPage> {
  late TextEditingController codeController;

  @override
  void initState() {
    codeController = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: 'editor.code.title'.tr()),
        body: Center(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: ListView(children: [
                  TextField(
                      controller: codeController,
                      decoration: InputDecoration(
                          hintText: 'editor.code.hint'.tr(),
                          labelText: 'editor.code.label'.tr()),
                      minLines: 3,
                      maxLines: null),
                ]))),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              var data =
                  json.decode(codeController.text) as Map<String, dynamic>?;
              if (data != null) {
                Modular.to.pop(data);
              }
            },
            icon: const Icon(PhosphorIcons.checkLight),
            label: Text('editor.code.submit'.tr())));
  }
}
