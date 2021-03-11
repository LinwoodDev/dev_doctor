import 'dart:convert';

import 'package:dev_doctor/editor/bloc/server.dart';
import 'package:dev_doctor/editor/services/server.dart';
import 'package:hive/hive.dart';

class EditorService {
  final Box<String> _box = Hive.box<String>('editor');

  EditorService();

  List<ServerEditorService> get servers =>
      _box.values.map((e) => ServerEditorService(bloc: ServerEditorBloc.fromJson(json.decode(e))));
  ServerEditorService getServer(String name) =>
      servers.firstWhere((e) => e.bloc.server.name == name);
}
