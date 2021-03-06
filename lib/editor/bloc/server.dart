import 'package:dev_doctor/models/server.dart';

import 'course.dart';

class ServerEditorBloc {
  final CoursesServer server;
  final List<CourseEditorBloc> courses;

  ServerEditorBloc(this.server, {this.courses = const []});
  ServerEditorBloc.fromJson(Map<String, dynamic> json)
      : server = CoursesServer.fromJson(json['server']),
        courses =
            (json['courses'] as List<dynamic>).map((e) => CourseEditorBloc.fromJson(e)).toList();
}
