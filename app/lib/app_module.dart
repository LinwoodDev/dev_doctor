import 'package:dev_doctor/articles/home.dart';
import 'package:dev_doctor/articles/module.dart';
import 'package:dev_doctor/backends/home.dart';
import 'package:dev_doctor/backends/module.dart';
import 'package:dev_doctor/settings/home.dart';
import 'package:dev_doctor/settings/module.dart';
import 'package:dev_doctor/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'add.dart';
import 'app_widget.dart';
import 'courses/home.dart';
import 'courses/module.dart';
import 'editor/home.dart';
import 'editor/module.dart';
import 'home.dart';

class AppModule extends Module {
  // Provide a list of dependencies to inject into your project
  @override
  final List<Bind> binds = [];

  // Provide all the routes for your module
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => MyHomePage(), children: [
      ...HomeRoutes.values.map((e) => ChildRoute(e.route,
          child: (_, __) => e.widget, transition: TransitionType.fadeIn)),
      WildcardRoute(child: (_, __) => ErrorDisplay())
    ]),
    WildcardRoute(child: (_, __) => ErrorDisplay()),
    ModuleRoute('/editor', module: EditorModule()),
    ModuleRoute('/backends', module: BackendsModule()),
    ModuleRoute('/articles', module: ArticlesModule()),
    ModuleRoute('/settings', module: SettingsModule()),
    ModuleRoute('/courses', module: CourseModule()),
    ChildRoute('/error', child: (_, args) => ErrorDisplay()),
    ChildRoute('/add',
        child: (_, args) => AddServerPage(url: args.queryParams['url']!)),
  ];
}

enum HomeRoutes { home, backends, articles, courses, editor, settings }

extension HomeRoutesExtension on HomeRoutes {
  String get route {
    switch (this) {
      case HomeRoutes.home:
        return '/';
      case HomeRoutes.backends:
        return '/backends';
      case HomeRoutes.articles:
        return '/articles';
      case HomeRoutes.courses:
        return '/courses';
      case HomeRoutes.editor:
        return '/editor';
      case HomeRoutes.settings:
        return '/settings';
    }
  }

  Widget get widget {
    switch (this) {
      case HomeRoutes.home:
        return HomePage();
      case HomeRoutes.backends:
        return BackendsPage();
      case HomeRoutes.articles:
        return ArticlesPage();
      case HomeRoutes.courses:
        return CoursesPage();
      case HomeRoutes.editor:
        return EditorPage();
      case HomeRoutes.settings:
        return SettingsPage();
    }
  }

  static HomeRoutes fromRoute(String route) {
    return HomeRoutes.values.firstWhere((element) => element.route == route);
  }
}
