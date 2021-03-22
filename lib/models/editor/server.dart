import 'dart:convert';

import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:hive/hive.dart';

import 'course.dart';

@HiveType(typeId: 2)
class ServerEditorBloc extends HiveObject {
  @HiveField(0)
  CoursesServer server;
  @HiveField(1)
  String note;
  @HiveField(2)
  final List<CourseEditorBloc> _courses;

  List<CourseEditorBloc> get courses => List.unmodifiable(_courses);

  ServerEditorBloc(this.server, {List<CourseEditorBloc> courses = const [], this.note})
      : _courses = List<CourseEditorBloc>.unmodifiable(courses);
  ServerEditorBloc.fromJson(Map<String, dynamic> json)
      : server = CoursesServer.fromJson(json['server'] ?? {}),
        note = json['note'],
        _courses = List<CourseEditorBloc>.unmodifiable((json['courses'] as List<dynamic> ?? [])
            .map((e) => CourseEditorBloc.fromJson(e))
            .toList(growable: false));
  factory ServerEditorBloc.fromKey(int key) =>
      ServerEditorBloc.fromJson(json.decode(Hive.box<String>('editor').get(key))..['key'] = key);
  Map<String, dynamic> toJson() => {
        "server": server.toJson(),
        "note": note,
        "courses": _courses.map((e) => e.toJson()).toList()
      };

  List<String> getCourseSlugs() => _courses.map((e) => e.course.slug).toList();
  CourseEditorBloc createCourse(String slug) {
    if (getCourseSlugs().contains(slug)) return null;
    var courseBloc = CourseEditorBloc(Course(name: slug, slug: slug));
    _courses.add(courseBloc);
    return courseBloc;
  }

  void deleteCourse(String slug) => _courses.removeWhere((element) => element.course.slug == slug);

  CourseEditorBloc getCourse(String slug) =>
      _courses.firstWhere((element) => element.course.slug == slug);
  CourseEditorBloc changeCourseSlug(String oldSlug, String newSlug) {
    var courseBloc = getCourse(oldSlug);
    var course = courseBloc.course.copyWith(slug: newSlug);
    var newBloc = CourseEditorBloc(course, parts: courseBloc.parts);
    _courses[_courses.indexOf(courseBloc)] = newBloc;
    return newBloc;
  }
}
