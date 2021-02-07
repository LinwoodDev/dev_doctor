import 'package:dev_doctor/courses/course.dart';
import 'package:dev_doctor/courses/part/module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home.dart';

class CourseModule extends ChildModule {
  // TODO: Test
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => CoursesPage()),
        ChildRoute('/details', child: (_, args) {
          print(args.queryParams);
          return CoursePage(
              model: args.data,
              serverId: int.parse(args.queryParams['serverId']),
              courseId: int.parse(args.queryParams['courseId']));
        }),
        ModuleRoute('/start', module: CoursePartModule()),
      ];
}
