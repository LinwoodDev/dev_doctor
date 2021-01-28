import 'package:dev_doctor/courses/course.dart';
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
            courseId: int.parse(args.params['courseId'])))
  ];
}
