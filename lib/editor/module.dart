import 'package:dev_doctor/backends/entry.dart';
import 'package:dev_doctor/courses/course.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home.dart';
import 'markdown.dart';

class EditorModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => EditorPage()),
        ChildRoute('/details', child: (_, args) {
          var bloc = ServerEditorBloc.fromKey(int.parse(args.queryParams['serverId']));
          return BackendPage(editorBloc: bloc);
        }),
        ChildRoute('/course', child: (_, args) {
          var bloc = ServerEditorBloc.fromKey(int.parse(args.queryParams['serverId']));
          return CoursePage(editorBloc: bloc, course: args.queryParams['course']);
        }),
        ChildRoute('/edit', child: (_, args) {
          var bloc = ServerEditorBloc.fromKey(int.parse(args.queryParams['serverId']));
          return MarkdownEditor(
              markdown: bloc.server.body,
              onSubmit: (value) => bloc.server = bloc.server.copyWith(body: value));
        })
      ];
}
