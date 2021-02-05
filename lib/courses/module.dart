import 'package:dev_doctor/courses/course.dart';
import 'package:dev_doctor/courses/part/item.dart';
import 'package:dev_doctor/courses/part/layout.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'bloc.dart';
import 'home.dart';

class CourseModule extends ChildModule {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => CoursesPage()),
        ChildRoute('/:serverId/:courseId',
            child: (_, args) => CoursePage(
                model: args.data,
                serverId: int.parse(args.params['serverId']),
                courseId: int.parse(args.params['courseId']))),
        ChildRoute('/:serverId/:courseId/start',
            child: (_, args) => PartItemPage(
                serverId: int.parse(args.params['serverId']),
                courseId: int.parse(args.params['courseId']))),
        ChildRoute('/:serverId/:courseId/start/:partId',
            child: (_, args) => PartItemLayout(),
            children: [
              ChildRoute('/', child: (_, args) => PartItemPage()),
              ChildRoute('/:itemId',
                  child: (_, args) => PartItemPage(itemId: args.params['itemId']))
            ]),
      ];

  @override
  List<Bind<Object>> get binds => [
        Bind((i) => CoursePartBloc(
            serverId: int.parse(i.args.params['serverId']),
            courseId: int.parse(i.args.params['courseId']),
            partId: int.parse(i.args.params['partId'])))
      ];
}
