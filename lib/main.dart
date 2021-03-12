import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'app_module.dart';
import 'app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('appearance');
  await Hive.openBox<String>('editor');
  var _serversBox = await Hive.openBox<String>('servers');
  var _collectionsBox = await Hive.openBox<String>('collections');
  if (_collectionsBox.isEmpty) await _collectionsBox.add('https://collection.dev-doctor.cf');
  if (_serversBox.isEmpty) await _serversBox.add('https://backend.dev-doctor.cf');
  runApp(ModularApp(module: AppModule(), child: AppWidget()));

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
    doWhenWindowReady(() {
      final initialSize = Size(600, 450);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
}
