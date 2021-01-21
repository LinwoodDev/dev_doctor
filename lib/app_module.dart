import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_widget.dart';

class AppModule extends MainModule {
  // Provide a list of dependencies to inject into your project
  @override
  final List<Bind> binds = [];

  // Provide all the routes for your module
  @override
  final List<ModularRoute> routes = [ChildRoute('/', child: (_, __) => MyHomePage())];

  // Provide the root widget associated with your module
  // In this case, it's the widget you created in the first step
  @override
  final Widget bootstrap = AppWidget();
}
