import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';

import 'app_module.dart';
import 'app_widget.dart';
import 'models/editor/course.dart';
import 'widgets/appbar.dart';

const kApiVersion = 16;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (isWindow()) {
    await windowManager.ensureInitialized();
  }

  await Hive.initFlutter('Dev-Doctor');
  await Hive.openBox('settings');
  await Hive.openBox('general');
  await Hive.openBox('appearance');
  await Hive.openBox<bool>('favorite');
  await Hive.openBox<ServerEditorBloc>('editor');
  await Hive.openBox<int>('points');
  Modular.setInitialRoute('/home');

  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
  Hive.registerAdapter(CoursesServerAdapter());
  Hive.registerAdapter(CourseAdapter(apiVersion: kApiVersion));
  Hive.registerAdapter(ServerEditorBlocAdapter(apiVersion: kApiVersion));
  Hive.registerAdapter(CourseEditorBlocAdapter(apiVersion: kApiVersion));
  var serversBox = await Hive.openBox<String>('servers');
  var collectionsBox = await Hive.openBox<String>('collections');
  if (collectionsBox.isEmpty) {
    await collectionsBox.add('https://collection.dev-doctor.linwood.dev');
  }
  if (serversBox.isEmpty) {
    await serversBox.add('https://backend.dev-doctor.linwood.dev');
  }

  if (isWindow()) {
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      await windowManager.setMinimumSize(const Size(400, 300));
      await windowManager.setSize(const Size(400, 600));
      await windowManager.setAlignment(Alignment.center);
      await windowManager.setTitle("Dev-Doctor");
      await windowManager.show();
    });
  }
}
