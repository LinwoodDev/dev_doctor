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
  factory ServerEditorBloc.fromKey(int key) =>
      ServerEditorBloc.fromJson(json.decode(Hive.box<String>('editor').get(key))..['key'] = key);
  Map<String, dynamic> toJson() =>
      {"server": server.toJson(), "note": note, "courses": courses.map((e) => e.toJson()).toList()};

  Future<ServerEditorBloc> save() async {
    var box = Hive.box<String>('editor');
    var data = json.encode(toJson());
    if (key != null)
      box.put(key, data);
    else
      return ServerEditorBloc(server, key: await box.add(data), courses: courses, note: note);
    return this;
  }

  ServerEditorBloc copyWith({CoursesServer server, String note, List<CourseEditorBloc> courses}) =>
      ServerEditorBloc(server ?? this.server,
          key: key, courses: courses ?? this.courses, note: note ?? this.note);

  CourseEditorBloc getCourse(String name) =>
      courses.firstWhere((element) => element.course.name == name);
}
