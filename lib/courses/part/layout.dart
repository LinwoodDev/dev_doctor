import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PartItemLayout extends StatefulWidget {
  @override
  _PartItemLayoutState createState() => _PartItemLayoutState();
}

class _PartItemLayoutState extends State<PartItemLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("TEST"),
        ),
        body: RouterOutlet());
  }
}
