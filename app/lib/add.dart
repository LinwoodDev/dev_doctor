import 'package:dev_doctor/settings/servers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:easy_localization/easy_localization.dart';

import 'models/server.dart';

class AddServerPage extends StatefulWidget {
  final String url;

  const AddServerPage({Key? key, required this.url}) : super(key: key);
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
    var url = widget.url;
    if (!_serversBox.containsKey(url)) {
      var server = await CoursesServer.fetch(url: url);
      if (server != null) {
        var shouldAdd = await (showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                    actions: [
                      TextButton(
                          child: Text("disagree").tr(),
                          onPressed: () => Navigator.of(context).pop(false)),
                      TextButton(
                          child: Text("agree").tr(),
                          onPressed: () => Navigator.of(context).pop(true))
                    ],
                    title: Text("settings.servers.add.title")
                        .tr(namedArgs: {"name": server.name, "url": server.url}),
                    content: Text("settings.servers.add.body")
                        .tr(namedArgs: {"name": server.name, "url": server.url}))));
        if (shouldAdd!) {
          await _serversBox.add(url);
          var params = Modular.args.queryParams;
          if (params.containsKey("redirect")) {
            Modular.to.pushReplacementNamed(params['redirect']!);
            return;
          }
        }
      }
    }
    Modular.to.navigate('/');
  }

  @override
  Widget build(BuildContext context) {
    return ServersSettingsPage();
  }
}
