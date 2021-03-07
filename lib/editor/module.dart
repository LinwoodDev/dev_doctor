import 'package:flutter_modular/flutter_modular.dart';

import 'create.dart';
import 'home.dart';

class EditorModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => EditorPage()),
      ];
}
