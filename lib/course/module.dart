import 'package:dev_doctor/course/home.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CourseModule extends ChildModule {
  @override
  final List<ModularRoute> routes = [ChildRoute('/', child: (_, args) => CoursePage())];
}
