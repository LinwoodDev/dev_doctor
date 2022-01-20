import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/text_divider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: "settings.title".tr()),
        body: const SettingsList());
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
              leading: const Icon(PhosphorIcons.wrenchLight),
              title: const Text("settings.general.title").tr(),
              onTap: () => activePage != null
                  ? Modular.to.pushReplacementNamed('/settings/general')
                  : Modular.to.pushNamed("/settings/general")),
          ListTile(
              selected: activePage == SettingsPages.appearance,
              leading: const Icon(PhosphorIcons.fadersLight),
              title: const Text("settings.appearance.title").tr(),
              onTap: () => activePage != null
                  ? Modular.to.pushReplacementNamed('/settings/appearance')
                  : Modular.to.pushNamed("/settings/appearance")),
          // ListTile(
          //     selected: activePage == SettingsPages.downloads,
          //     leading: Icon(Icons.download_outlined),
          //     title: Text("settings.downloads.title").tr(),
          //     onTap: () => _showComingSoon(context)),
          ListTile(
              selected: activePage == SettingsPages.servers,
              leading: const Icon(PhosphorIcons.cardsLight),
              title: const Text("settings.servers.title").tr(),
              onTap: () => activePage != null
                  ? Modular.to.pushReplacementNamed('/settings/servers')
                  : Modular.to.pushNamed("/settings/servers")),
          ListTile(
              selected: activePage == SettingsPages.collections,
              leading: const Icon(PhosphorIcons.treeStructureLight),
              title: const Text("settings.collections.title").tr(),
              onTap: () => activePage != null
                  ? Modular.to.pushReplacementNamed('/settings/collections')
                  : Modular.to.pushNamed("/settings/collections")),
          TextDivider(text: 'settings.information'.tr().toUpperCase()),
          ListTile(
              leading: const Icon(PhosphorIcons.stackLight),
              title: const Text("settings.license").tr(),
              onTap: () => launch(
                  "https://github.com/LinwoodCloud/dev_doctor/blob/main/LICENSE")),
          ListTile(
              leading: const Icon(PhosphorIcons.codeLight),
              title: const Text("settings.code").tr(),
              onTap: () =>
                  launch("https://github.com/LinwoodCloud/dev_doctor")),
          ListTile(
              leading: const Icon(PhosphorIcons.usersLight),
              title: const Text("discord").tr(),
              onTap: () => launch("https://discord.linwood.dev")),
          ListTile(
              leading: const Icon(PhosphorIcons.articleLight),
              title: const Text("docs").tr(),
              onTap: () => launch(
                  "https://docs.dev-doctor.linwood.dev/backend/overview")),
          ListTile(
              leading: const Icon(PhosphorIcons.arrowCounterClockwiseLight),
              title: const Text("settings.changelog").tr(),
              onTap: () =>
                  launch("https://docs.dev-doctor.linwood.dev/changelog")),
          ListTile(
              leading: const Icon(PhosphorIcons.identificationCardLight),
              title: const Text("settings.imprint").tr(),
              onTap: () => launch("https://codedoctor.tk/impress")),
          ListTile(
              leading: const Icon(PhosphorIcons.shieldLight),
              title: const Text("settings.privacypolicy").tr(),
              onTap: () => launch(
                  "https://docs.dev-doctor.linwood.dev/docs/privacypolicy")),
          ListTile(
              leading: const Icon(PhosphorIcons.infoLight),
              title: const Text("settings.about").tr(),
              onTap: () => showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset("images/logo.png", height: 50))),
        ])))));
  }
}
