import 'package:dev_doctor/settings/general.dart';
import 'package:dev_doctor/settings/servers.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'appearance.dart';
import 'collections.dart';

class SettingsModule extends Module {
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/general', child: (_, args) => GeneralSettingsPage()),
    ChildRoute('/servers', child: (_, args) => ServersSettingsPage()),
    ChildRoute('/appearance', child: (_, args) => AppearanceSettingsPage()),
    ChildRoute('/collections', child: (_, args) => CollectionsSettingsPage())
  ];
}
