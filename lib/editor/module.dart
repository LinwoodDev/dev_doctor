import 'package:dev_doctor/backends/entry.dart';
import 'package:dev_doctor/courses/course.dart';
import 'package:dev_doctor/courses/part/item.dart';
import 'package:dev_doctor/editor/author.dart';
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
              onSubmit: (value) {
                bloc.server = bloc.server.copyWith(body: value);
                bloc.save();
              });
        }),
        ChildRoute('/course/edit', child: (_, args) {
          var bloc = ServerEditorBloc.fromKey(int.parse(args.queryParams['serverId']));
          var course = args.queryParams['course'];
          var courseBloc = bloc.getCourse(course);
          return MarkdownEditor(
              markdown: courseBloc.course.body,
              onSubmit: (value) {
                courseBloc.course = courseBloc.course.copyWith(body: value);
                bloc.save();
              });
        }),
        ChildRoute('/course/author', child: (_, args) {
          var bloc = ServerEditorBloc.fromKey(int.parse(args.queryParams['serverId']));
          var course = args.queryParams['course'];
          var courseBloc = bloc.getCourse(course);
          return AuthorEditingPage(
              author: courseBloc.course.author,
              onSubmit: (value) {
                courseBloc.course = courseBloc.course.copyWith(author: value);
                bloc.save();
              });
        }),
        ChildRoute('/course/item', transition: TransitionType.defaultTransition, child: (_, args) {
          var bloc = ServerEditorBloc.fromKey(int.parse(args.queryParams['serverId']));
          return PartItemPage(
              model: args.data,
              editorBloc: bloc,
              itemId: int.parse(args?.queryParams['itemId'] ?? '0'));
        })
      ];
}
