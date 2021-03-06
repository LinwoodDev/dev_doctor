import 'package:dev_doctor/models/server.dart';
import 'package:flutter/cupertino.dart';

import 'course.dart';

@immutable
class ServerEditorBloc {
  final CoursesServer server;
  final String description;
  final List<CourseEditorBloc> courses;

  ServerEditorBloc(this.server, {this.courses = const [], this.description});
  ServerEditorBloc.fromJson(Map<String, dynamic> json)
      : server = CoursesServer.fromJson(json['server']),
        description = json['description'],
        courses =
            (json['courses'] as List<dynamic>).map((e) => CourseEditorBloc.fromJson(e)).toList();
  Map<String, dynamic> toJson() => {
        "server": server.toJson(),
        "description": description,
        "courses": courses.map((e) => e.toJson())
      };
}
