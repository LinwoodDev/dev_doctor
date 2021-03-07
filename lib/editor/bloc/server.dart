import 'package:dev_doctor/models/server.dart';
import 'package:flutter/cupertino.dart';

import 'course.dart';

@immutable
class ServerEditorBloc {
  final CoursesServer server;
  final String note;
  final List<CourseEditorBloc> courses;

  ServerEditorBloc(this.server, {this.courses = const [], this.note});
  ServerEditorBloc.fromJson(Map<String, dynamic> json)
      : server = CoursesServer.fromJson(json['server'] ?? {}),
        note = json['note'],
        courses = (json['courses'] as List<dynamic> ?? [])
            .map((e) => CourseEditorBloc.fromJson(e))
            .toList();
  Map<String, dynamic> toJson() =>
      {"server": server.toJson(), "note": note, "courses": courses.map((e) => e.toJson()).toList()};
}
