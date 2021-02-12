import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class EditorPage extends StatefulWidget {
  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: 'editor.title'.tr()),
        body: Center(child: Text("coming-soon").tr()));
  }
}
