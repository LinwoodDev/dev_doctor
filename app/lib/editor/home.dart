import 'package:animations/animations.dart';
import 'package:dev_doctor/editor/create.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final Box<ServerEditorBloc> _box = Hive.box<ServerEditorBloc>('editor');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: 'editor.title'.tr()),
        body: ValueListenableBuilder(
            valueListenable: _box.listenable(),
            builder: (context, dynamic value, child) => Scrollbar(
                child: ListView.builder(
                    itemCount: _box.length,
                    itemBuilder: (context, index) {
                      var key = _box.keyAt(index);
                      var bloc = ServerEditorBloc.fromKey(key);
                      return Dismissible(
                          key: Key(key.toString()),
                          background: Container(color: Colors.red),
                          onDismissed: (direction) {
                            _box.delete(key);
                          },
                          child: ListTile(
                              title: Text(bloc.server.name),
                              subtitle: Text(bloc.note!),
                              onTap: () => Modular.to
                                  .pushNamed("/editor/details?serverId=$key")));
                    }))),
        floatingActionButton: OpenContainer(
            transitionType: ContainerTransitionType.fadeThrough,
            transitionDuration: const Duration(milliseconds: 750),
            openBuilder: (context, _) => const CreateServerPage(),
            closedShape: const CircleBorder(),
            closedBuilder: (context, openContainer) => FloatingActionButton(
                onPressed: openContainer,
                tooltip: "editor.create.fab".tr(),
                child: const Icon(PhosphorIcons.plusLight))));
  }
}
