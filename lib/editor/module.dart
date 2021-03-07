import 'dart:convert';

import 'package:dev_doctor/backends/entry.dart';
import 'package:dev_doctor/editor/bloc/server.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';

import 'home.dart';

class EditorModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => EditorPage()),
        ChildRoute('/details', child: (_, args) {
          var bloc = getBloc(int.parse(args.queryParams['serverId']));
          return BackendPage(editorBloc: bloc);
        })
      ];
  ServerEditorBloc getBloc(int index) =>
      ServerEditorBloc.fromJson(json.decode(Hive.box<String>('editor').getAt(index)));
}
