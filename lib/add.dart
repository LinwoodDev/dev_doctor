import 'package:dev_doctor/settings/servers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:easy_localization/easy_localization.dart';

import 'app_widget.dart';
import 'models/server.dart';

class AddServerPage extends StatefulWidget {
  final Map<String, String> params;

  const AddServerPage({Key key, this.params}) : super(key: key);
  @override
  _AddServerPageState createState() => _AddServerPageState();
}

class _AddServerPageState extends State<AddServerPage> {
  final Box<String> _serversBox = Hive.box<String>('servers');
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _showDialog());
  }

  _showDialog() async {
    var url = widget.params['url'];
    if (_serversBox.containsKey(url)) {
      var server = await CoursesServer.fetch(url);
      var shouldAdd = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                  actions: [
                    FlatButton(
                        child: Text("settings.servers.add.disagree").tr(),
                        onPressed: () => Navigator.of(context).pop(false)),
                    FlatButton(
                        child: Text("settings.servers.add.agree").tr(),
                        onPressed: () => Navigator.of(context).pop(true))
                  ],
                  title: Text("settings.servers.add.title")
                      .tr(namedArgs: {"name": server.name, "url": server.url}),
                  content: Text("settings.servers.add.body")
                      .tr(namedArgs: {"name": server.name, "url": server.url})));
      if (shouldAdd) {
        await _serversBox.add(url);
      }
    }
    Modular.to.navigate('/');
  }

  @override
  Widget build(BuildContext context) {
    return ServersSettingsPage();
  }
}
