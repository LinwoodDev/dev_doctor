import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';

class EditorPage extends StatefulWidget {
  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: MyAppBar(title: 'Editor'), body: Center(child: Text("Coming soon...")));
  }
}
