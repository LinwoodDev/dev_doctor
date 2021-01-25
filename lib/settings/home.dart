import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/text_divider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: "settings.title".tr()),
        body: Container(
            child: Scrollbar(
                child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
          ListTile(leading: Icon(Icons.build_outlined), title: Text("General")),
          ListTile(
              leading: Icon(Icons.tune_outlined),
              title: Text("settings.appearance.title").tr(),
              onTap: () => Navigator.pushNamed(context, "/settings/appearance")),
          ListTile(leading: Icon(Icons.download_outlined), title: Text("Downloads")),
          ListTile(
              leading: Icon(Icons.list_outlined),
              title: Text("settings.servers.title").tr(),
              onTap: () => Navigator.pushNamed(context, "/settings/servers")),
          TextDivider(text: 'INFORMATION'),
          ListTile(
              leading: Icon(Icons.text_snippet_outlined),
              title: Text("settings.license").tr(),
              onTap: () => launch("https://github.com/LinwoodCloud/dev-doctor/blob/main/LICENSE")),
          ListTile(
              leading: Icon(Icons.construction_outlined),
              title: Text("settings.imprint").tr(),
              onTap: () => launch("https://codedoctor.tk/impress")),
          ListTile(
              leading: Icon(Icons.code_outlined),
              title: Text("settings.code").tr(),
              onTap: () => launch("https://github.com/LinwoodCloud/dev-doctor")),
          ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("settings.about").tr(),
              onTap: () => showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset("icons/logo-light.png", height: 50))),
        ])))));
  }
}
