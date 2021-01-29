import 'package:dev_doctor/courses/course.dart';
import 'package:dev_doctor/courses/part/item.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home.dart';

class CourseModule extends ChildModule {
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => CoursesPage()),
    ChildRoute('/:serverId/:courseId',
        child: (_, args) => CoursePage(
            model: args.data,
            serverId: int.parse(args.params['serverId']),
            courseId: int.parse(args.params['courseId']))),
    ChildRoute('/:serverId/:courseId/start',
        child: (_, args) => PartItemPage(
              serverId: int.parse(args.params['serverId']),
              courseId: int.parse(args.params['courseId']),
            )),
    ChildRoute('/:serverId/:courseId/start/:partId',
        child: (_, args) => PartItemPage(
              serverId: int.parse(args.params['serverId']),
              courseId: int.parse(args.params['courseId']),
              partId: int.parse(args.params['partId']),
            )),
    ChildRoute('/:serverId/:courseId/start/:partId/:itemId',
        child: (_, args) => PartItemPage(
            serverId: int.parse(args.params['serverId']),
            courseId: int.parse(args.params['courseId']),
            partId: int.parse(args.params['partId']),
            itemId: int.parse(args.params['itemId'])))
  ];
}
