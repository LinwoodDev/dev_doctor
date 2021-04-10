import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class CourseBloc extends Disposable {
  BehaviorSubject<Course> courseSubject = BehaviorSubject<Course>();
  String? course;
  bool _error = false;

  bool get hasError => _error;
  CoursePartBloc() {}
  Future<void> fetch(
      {ServerEditorBloc? editorBloc,
      String? server,
      int? serverId,
      String? course,
      int? courseId}) async {
    reset();
    try {
      var currentServer = editorBloc != null
          ? editorBloc.server
          : await CoursesServer.fetch(index: serverId, url: server);
      if (courseId != null) course = currentServer?.courses[courseId];
      this.course = course;
      var current = course == null
          ? null
          : editorBloc != null
              ? editorBloc.getCourse(course).course
              : await currentServer?.fetchCourse(course);
      courseSubject.add(current ?? Course(parts: [], slug: ''));
      if (current == null) _error = true;
    } catch (e) {
      print("Error $e");
      _error = true;
    }
  }

  Future<void> fetchFromParams({ServerEditorBloc? editorBloc}) {
    var params = Modular.args!.queryParams;
    return fetch(
        editorBloc: editorBloc,
        server: params['server'],
        course: params['course'],
        courseId: int.tryParse(params['courseId'] ?? ''),
        serverId: int.tryParse(params['serverId'] ?? ''));
  }

  void reset() {
    courseSubject = BehaviorSubject<Course>();
    _error = false;
  }

  @override
  void dispose() {
    courseSubject.close();
  }
}
