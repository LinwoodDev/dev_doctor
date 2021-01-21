import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app_module.dart';

void main() async {
  await Hive.initFlutter();
  var settingsBox = await Hive.openBox('settings');
  if (!settingsBox.containsKey('servers'))
    settingsBox.put('servers', ['https://backend.dev-doctor.cf']);
  runApp(ModularApp(module: AppModule()));
}
