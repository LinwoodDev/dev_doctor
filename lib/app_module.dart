import 'package:dev_doctor/settings/home.dart';
import 'package:dev_doctor/settings/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'add.dart';
import 'app_widget.dart';
import 'courses/home.dart';
import 'courses/module.dart';
import 'editor/home.dart';
import 'home.dart';

class AppModule extends Module {
  // Provide a list of dependencies to inject into your project
  @override
  final List<Bind> binds = [];

  // Provide all the routes for your module
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => MyHomePage(), children: [
      ...HomeRoutes.values.map((e) =>
          ChildRoute(e.route, child: (_, __) => e.widget, transition: TransitionType.fadeIn)),
    ]),
    ModuleRoute('/settings', module: SettingsModule()),
    ModuleRoute('/courses', module: CourseModule()),
    ChildRoute('/add', child: (_, args) => AddServerPage(params: args.queryParams)),
  ];
}

enum HomeRoutes { home, courses, editor, settings }

extension HomeRoutesExtension on HomeRoutes {
  String get route {
    switch (this) {
      case HomeRoutes.home:
        return '/';
      case HomeRoutes.courses:
        return '/courses';
      case HomeRoutes.editor:
        return '/editor';
      case HomeRoutes.settings:
        return '/settings';
    }
    return null;
  }

  Widget get widget {
    switch (this) {
      case HomeRoutes.home:
        return HomePage();
      case HomeRoutes.courses:
        return CoursesPage();
      case HomeRoutes.editor:
        return EditorPage();
      case HomeRoutes.settings:
        return SettingsPage();
    }
    return null;
  }

  static HomeRoutes fromRoute(String route) {
    return HomeRoutes.values.firstWhere((element) => element.route == route);
  }
}
