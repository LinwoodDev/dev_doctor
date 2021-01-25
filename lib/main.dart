import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app_module.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('appearance');
  var _serversBox = await Hive.openBox<String>('servers');
  if (_serversBox.isEmpty) await _serversBox.add('https://backend.dev-doctor.cf');
  runApp(ModularApp(module: AppModule()));
}
