import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/text_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
        appBar: MyAppBar(title: "settings.title".tr()), body: Container(child: SettingsList()));
  }
}

enum SettingsPages { general, appearance, downloads, servers, collections }

class SettingsList extends StatelessWidget {
  final SettingsPages? activePage;

  const SettingsList({Key? key, this.activePage}) : super(key: key);
  _showComingSoon(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("coming-soon").tr(),
              actions: [
                TextButton.icon(
                  icon: Icon(Icons.close_outlined),
                  label: Text("close".tr().toUpperCase()),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "settings",
        child: Material(
            child: Scrollbar(
                child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
          ListTile(
              selected: activePage == SettingsPages.general,
              leading: Icon(Icons.build_outlined),
              title: Text("settings.general.title").tr(),
              onTap: () => _showComingSoon(context)),
          ListTile(
              selected: activePage == SettingsPages.appearance,
              leading: Icon(Icons.tune_outlined),
              title: Text("settings.appearance.title").tr(),
              onTap: () => Modular.to.pushNamed("/settings/appearance")),
          ListTile(
              selected: activePage == SettingsPages.downloads,
              leading: Icon(Icons.download_outlined),
              title: Text("settings.downloads.title").tr(),
              onTap: () => _showComingSoon(context)),
          ListTile(
              selected: activePage == SettingsPages.servers,
              leading: Icon(Icons.list_outlined),
              title: Text("settings.servers.title").tr(),
              onTap: () => Modular.to.pushNamed("/settings/servers")),
          ListTile(
              selected: activePage == SettingsPages.collections,
              leading: Icon(Icons.library_books_outlined),
              title: Text("settings.collections.title").tr(),
              onTap: () => Modular.to.pushNamed("/settings/collections")),
          TextDivider(text: 'settings.information'.tr().toUpperCase()),
          ListTile(
              leading: Icon(Icons.text_snippet_outlined),
              title: Text("settings.license").tr(),
              onTap: () => launch("https://github.com/LinwoodCloud/dev-doctor/blob/main/LICENSE")),
          ListTile(
              leading: Icon(Icons.code_outlined),
              title: Text("settings.code").tr(),
              onTap: () => launch("https://github.com/LinwoodCloud/dev-doctor")),
          ListTile(
              leading: Icon(Icons.history_outlined),
              title: Text("settings.changelog").tr(),
              onTap: () =>
                  launch("https://github.com/LinwoodCloud/dev_doctor/blob/main/CHANGELOG.md")),
          ListTile(
              leading: Icon(Icons.supervisor_account_outlined),
              title: Text("discord").tr(),
              onTap: () => launch("https://discord.linwood.tk")),
          ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text("docs").tr(),
              onTap: () => launch("https://docs.dev-doctor.cf/backend/overview")),
          ListTile(
              leading: Icon(Icons.history_outlined),
              title: Text("settings.changelog").tr(),
              onTap: () =>
                  launch("https://github.com/LinwoodCloud/dev_doctor/blob/main/CHANGELOG.md")),
          ListTile(
              leading: Icon(Icons.construction_outlined),
              title: Text("settings.imprint").tr(),
              onTap: () => launch("https://codedoctor.tk/impress")),
          ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text("settings.privacypolicy").tr(),
              onTap: () => launch("https://docs.dev-doctor.cf/privacypolicy")),
          ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("settings.about").tr(),
              onTap: () => showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset("images/logo-colored.png", height: 50))),
        ])))));
  }
}
