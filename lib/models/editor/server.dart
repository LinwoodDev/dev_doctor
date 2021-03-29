import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:hive/hive.dart';

import 'course.dart';

class ServerEditorBloc extends HiveObject {
  CoursesServer _server;
  String note;
  final List<CourseEditorBloc> _courses;

  CoursesServer get server =>
      _server.copyWith(courses: _courses.map((e) => e.course.slug).toList());
  set server(CoursesServer value) => _server = value;

  List<CourseEditorBloc> get courses => List.unmodifiable(_courses);

  ServerEditorBloc({List<CourseEditorBloc> courses = const [], this.note, String name})
      : _server = CoursesServer(name: name),
        _courses = List<CourseEditorBloc>.from(courses);
  ServerEditorBloc.fromJson(Map<String, dynamic> json)
      : _server = CoursesServer.fromJson(Map<String, dynamic>.from(json['server'] ?? {})),
        note = json['note'],
        _courses = List<CourseEditorBloc>.from((json['courses'] as List<dynamic> ?? [])
            .map((e) => CourseEditorBloc.fromJson(Map<String, dynamic>.from(e)))
            .toList(growable: false));
  factory ServerEditorBloc.fromKey(int key) => Hive.box<ServerEditorBloc>('editor').get(key);
  Map<String, dynamic> toJson(int apiVersion) => {
        "server": server.toJson(),
        "note": note,
        "courses": _courses.map((e) => e.toJson(apiVersion)).toList()
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

class ServerEditorBlocAdapter extends TypeAdapter<ServerEditorBloc> {
  final int apiVersion;

  ServerEditorBlocAdapter({this.apiVersion});
  @override
  ServerEditorBloc read(BinaryReader reader) =>
      ServerEditorBloc.fromJson(Map<String, dynamic>.from(reader.read()));

  @override
  final typeId = 2;

  @override
  void write(BinaryWriter writer, ServerEditorBloc obj) {
    writer.write(obj.toJson(apiVersion));
  }
}
