import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_widget.dart';

class AppModule extends MainModule {
  // Provide a list of dependencies to inject into your project
  @override
  final List<Bind> binds = [];

  // Provide all the routes for your module
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/start', child: (context, args) => MyHomePage(), children: [
      ...HomeRoutes.values.map((e) =>
          ChildRoute(e.route, child: (_, __) => e.widget, transition: TransitionType.noTransition))
    ])
  ];

  // Provide the root widget associated with your module
  // In this case, it's the widget you created in the first step
  @override
  final Widget bootstrap = AppWidget();
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
    return MyHomePage(index: index);
  }

  static HomeRoutes fromIndex(int index) {
    return HomeRoutes.values.firstWhere((element) => element.index == index);
  }
}
