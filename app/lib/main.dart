import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app_module.dart';
import 'app_widget.dart';
import 'models/editor/course.dart';
import 'widgets/appbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Hive.initFlutter('Dev-Doctor');
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  var buildNumber = int.tryParse(packageInfo.buildNumber);
  Hive.registerAdapter(CoursesServerAdapter());
  Hive.registerAdapter(CourseAdapter(apiVersion: buildNumber));
  Hive.registerAdapter(ServerEditorBlocAdapter(apiVersion: buildNumber));
  Hive.registerAdapter(CourseEditorBlocAdapter(apiVersion: buildNumber));
  await Hive.openBox('settings');
  await Hive.openBox('general');
  await Hive.openBox('appearance');
  await Hive.openBox<bool>('favorite');
  await Hive.openBox<ServerEditorBloc>('editor');
  await Hive.openBox<int>('points');
  var _serversBox = await Hive.openBox<String>('servers');
  var _collectionsBox = await Hive.openBox<String>('collections');
  if (_collectionsBox.isEmpty)
    await _collectionsBox.add('https://collection.dev-doctor.linwood.dev');
  if (_serversBox.isEmpty)
    await _serversBox.add('https://backend.dev-doctor.linwood.dev');
  runApp(ModularApp(module: AppModule(), child: AppWidget()));

  if (isWindow())
    doWhenWindowReady(() {
      appWindow.minSize = Size(400, 300);
      appWindow.size = Size(400, 600);
      appWindow.alignment = Alignment.center;
      appWindow.title = "Dev-Doctor";
      appWindow.show();
    });
}
