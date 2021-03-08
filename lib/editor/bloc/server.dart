import 'dart:convert';

import 'package:dev_doctor/models/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import 'course.dart';

@immutable
class ServerEditorBloc {
  final CoursesServer server;
  final String note;
  final int key;
  final List<CourseEditorBloc> courses;

  ServerEditorBloc(this.server, {this.key, this.courses = const [], this.note});
  ServerEditorBloc.fromJson(Map<String, dynamic> json)
      : server = CoursesServer.fromJson(json['server'] ?? {}),
        note = json['note'],
        key = json['key'],
        courses = (json['courses'] as List<dynamic> ?? [])
            .map((e) => CourseEditorBloc.fromJson(e))
            .toList();
  Map<String, dynamic> toJson() =>
      {"server": server.toJson(), "note": note, "courses": courses.map((e) => e.toJson()).toList()};

  void save() {
    Hive.box<String>('editor').put(key, json.encode(toJson()));
  }

  ServerEditorBloc copyWith(
          {CoursesServer server, String note, int key, List<CourseEditorBloc> courses}) =>
      ServerEditorBloc(server ?? this.server,
          key: key, courses: courses ?? this.courses, note: note ?? this.note);

  CourseEditorBloc getCourse(String name) {
    return courses.firstWhere((element) => element.course.name == name);
  }
}
