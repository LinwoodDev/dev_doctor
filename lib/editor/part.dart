import 'package:dev_doctor/backends/entry.dart';
import 'package:dev_doctor/courses/course.dart';
import 'package:dev_doctor/courses/part/bloc.dart';
import 'package:dev_doctor/courses/part/item.dart';
import 'package:dev_doctor/editor/author.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EditorPartModule extends Module {
  static Inject get to => Inject<EditorPartModule>();
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/item', transition: TransitionType.defaultTransition, child: (_, args) {
          var bloc = ServerEditorBloc.fromKey(int.parse(args.queryParams['serverId']));
          return PartItemPage(
              model: args.data,
              editorBloc: bloc,
              itemId: int.parse(args?.queryParams['itemId'] ?? '0'));
        })
      ];
  @override
  List<Bind<Object>> get binds => [Bind.singleton((i) => CoursePartBloc())];
}
