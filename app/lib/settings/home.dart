import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/text_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
  // _showComingSoon(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             title: Text("coming-soon").tr(),
  //             actions: [
  //               TextButton.icon(
  //                 icon: Icon(PhosphorIcons.xLight),
  //                 label: Text("close".tr().toUpperCase()),
  //                 onPressed: () => Navigator.of(context).pop(),
  //               )
  //             ],
  //           ));
  // }

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
              leading: Icon(PhosphorIcons.wrench),
              title: Text("settings.general.title").tr(),
              onTap: () => Modular.to.pushNamed("/settings/general")),
          ListTile(
              selected: activePage == SettingsPages.appearance,
              leading: Icon(PhosphorIcons.fadersLight),
              title: Text("settings.appearance.title").tr(),
              onTap: () => Modular.to.pushNamed("/settings/appearance")),
          // ListTile(
          //     selected: activePage == SettingsPages.downloads,
          //     leading: Icon(Icons.download_outlined),
          //     title: Text("settings.downloads.title").tr(),
          //     onTap: () => _showComingSoon(context)),
          ListTile(
              selected: activePage == SettingsPages.servers,
              leading: Icon(PhosphorIcons.cardsLight),
              title: Text("settings.servers.title").tr(),
              onTap: () => Modular.to.pushNamed("/settings/servers")),
          ListTile(
              selected: activePage == SettingsPages.collections,
              leading: Icon(PhosphorIcons.treeStructureLight),
              title: Text("settings.collections.title").tr(),
              onTap: () => Modular.to.pushNamed("/settings/collections")),
          TextDivider(text: 'settings.information'.tr().toUpperCase()),
          ListTile(
              leading: Icon(PhosphorIcons.stackLight),
              title: Text("settings.license").tr(),
              onTap: () => launch("https://github.com/LinwoodCloud/dev-doctor/blob/main/LICENSE")),
          ListTile(
              leading: Icon(PhosphorIcons.codeLight),
              title: Text("settings.code").tr(),
              onTap: () => launch("https://github.com/LinwoodCloud/dev-doctor")),
          ListTile(
              leading: Icon(PhosphorIcons.usersLight),
              title: Text("discord").tr(),
              onTap: () => launch("https://discord.linwood.tk")),
          ListTile(
              leading: Icon(PhosphorIcons.articleLight),
              title: Text("docs").tr(),
              onTap: () => launch("https://docs.dev-doctor.cf/backend/overview")),
          ListTile(
              leading: Icon(PhosphorIcons.arrowCounterClockwiseLight),
              title: Text("settings.changelog").tr(),
              onTap: () => launch("https://docs.dev-doctor.cf/changelog")),
          ListTile(
              leading: Icon(PhosphorIcons.identificationCardLight),
              title: Text("settings.imprint").tr(),
              onTap: () => launch("https://codedoctor.tk/impress")),
          ListTile(
              leading: Icon(PhosphorIcons.shieldLight),
              title: Text("settings.privacypolicy").tr(),
              onTap: () => launch("https://docs.dev-doctor.cf/privacypolicy")),
          ListTile(
              leading: Icon(PhosphorIcons.infoLight),
              title: Text("settings.about").tr(),
              onTap: () => showAboutDialog(
                  context: context, applicationIcon: Image.asset("images/logo.png", height: 50))),
        ])))));
  }
}
