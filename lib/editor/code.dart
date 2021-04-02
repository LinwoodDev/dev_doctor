import 'dart:convert';

import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

typedef EditorCallback = void Function(Map<String, dynamic> json);

class EditorCodeDialogPage extends StatefulWidget {
  final String initialValue;
  final EditorCallback onSubmit;

  const EditorCodeDialogPage({Key? key, required this.initialValue, required this.onSubmit})
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
        body: Scrollbar(
            child: Container(
                constraints: BoxConstraints(maxWidth: 1000),
                child: ListView(children: [
                  TextField(
                      controller: codeController,
                      decoration: InputDecoration(
                          hintText: 'editor.code.hint'.tr(), labelText: 'editor.code.label'.tr()),
                      minLines: 3,
                      maxLines: null),
                  Wrap(children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          var data = json.decode(codeController.text);
                          if (data != null) {
                            Modular.to.pop();
                            widget.onSubmit(data);
                          }
                        },
                        icon: Icon(Icons.check_outlined),
                        label: Text('editor.code.submit'.tr())),
                    ElevatedButton.icon(
                        onPressed: () =>
                            Clipboard.setData(ClipboardData(text: codeController.text)),
                        icon: Icon(Icons.copy_outlined),
                        label: Text('editor.code.copy'.tr()))
                  ])
                ]))));
  }
}
