import 'package:dev_doctor/pages/settings/servers.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/text_divider.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: "Settings"),
        body: Container(
            child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.max, children: [
          ListTile(leading: Icon(Icons.build_outlined), title: Text("General")),
          ListTile(leading: Icon(Icons.tune_outlined), title: Text("Appearance")),
          ListTile(leading: Icon(Icons.download_outlined), title: Text("Downloads")),
          ListTile(
              leading: Icon(Icons.list_outlined),
              title: Text("Servers"),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ServersSettingsPage()))),
          TextDivider(text: 'INFORMATION'),
          ListTile(leading: Icon(Icons.text_snippet_outlined), title: Text("Licenses")),
          ListTile(leading: Icon(Icons.construction_outlined), title: Text("Impress")),
          ListTile(leading: Icon(Icons.code_outlined), title: Text("Sources"))
        ]))));
  }
}
