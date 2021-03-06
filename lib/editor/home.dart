import 'dart:convert';

import 'package:dev_doctor/editor/bloc/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditorPage extends StatefulWidget {
  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  Box<String> _box = Hive.box<String>('editor');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: 'editor.title'.tr()),
        body: ValueListenableBuilder(
            valueListenable: _box.listenable(),
            builder: (context, value, child) => Scrollbar(
                child: ListView.builder(
                    itemCount: _box.length,
                    itemBuilder: (context, index) {
                      var item = json.decode(_box.getAt(index));
                      var bloc = ServerEditorBloc.fromJson(item);
                      return ListTile(title: Text(bloc.server.name));
                    }))),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Modular.to.pushNamed("/editor/create"),
            icon: Icon(Icons.add_outlined),
            label: Text("editor.create.fab").tr()));
  }
}
