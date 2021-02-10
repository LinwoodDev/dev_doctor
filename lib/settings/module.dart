import 'package:dev_doctor/settings/servers.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'appearance.dart';

class SettingsModule extends Module {
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/servers', child: (_, args) => ServersSettingsPage()),
    ChildRoute('/appearance', child: (_, args) => AppearanceSettingsPage())
  ];
}
