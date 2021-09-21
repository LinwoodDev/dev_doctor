import 'package:dev_doctor/courses/part/bloc.dart';
import 'package:dev_doctor/courses/part/item.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'item.dart';

class EditorPartModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', transition: TransitionType.defaultTransition, child: (_, args) {
          var bloc = ServerEditorBloc.fromKey(int.parse(args.queryParams['serverId']!));
          return PartItemPage(
              model: args.data,
              editorBloc: bloc,
              itemId: int.parse(args.queryParams['itemId'] ?? '0'));
        }),
        ChildRoute('/edit', child: (_, args) {
          var params = Modular.args.queryParams;
          var bloc = ServerEditorBloc.fromKey(int.parse(params['serverId']!));
          return PartItemEditorPage(
            editorBloc: bloc,
            course: params['course'],
            courseId: int.tryParse(params['courseId'] ?? ''),
            part: params['part'],
            partId: int.tryParse(params['partId'] ?? ''),
            itemId: int.tryParse(params['itemId'] ?? '0'),
          );
        })
      ];
  @override
  List<Bind<Object>> get binds => [Bind.singleton((i) => CoursePartBloc())];
}
