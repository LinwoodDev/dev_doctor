import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';

class ServersSettingsPage extends StatefulWidget {
  @override
  _ServersSettingsPageState createState() => _ServersSettingsPageState();
}

class _ServersSettingsPageState extends State<ServersSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: MyAppBar(title: "Server Settings"), body: Container());
  }
}
