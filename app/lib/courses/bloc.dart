import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class CourseBloc extends Disposable {
  BehaviorSubject<Course> courseSubject = BehaviorSubject<Course>();
  String? course;
  @protected
  bool error = false;

  bool get hasError => error;
  CoursePartBloc() {}
  Future<void> fetch(
      {ServerEditorBloc? editorBloc,
      String? server,
      int? serverId,
      String? course,
      int? courseId,
      bool redirectAddServer = true}) async {
    reset();
    try {
      var currentServer = editorBloc != null
          ? editorBloc.server
          : await CoursesServer.fetch(index: serverId, url: server);
      if (!(currentServer?.added ?? false) && server != null)
        Modular.to.pushNamed(Uri(
            pathSegments: ["", "add"],
            queryParameters: {"url": server, "redirect": Modular.to.path}).toString());
      if (courseId != null) course = currentServer?.courses[courseId];
      this.course = course;
      var current = course == null
          ? null
          : editorBloc != null
              ? editorBloc.getCourse(course).course
              : await currentServer?.fetchCourse(course);
      print(current);
      courseSubject.add(current ?? Course(parts: [], slug: ''));
      if (current == null) error = true;
    } catch (e) {
      print("Error $e");
      error = true;
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
    error = false;
  }

  @override
  void dispose() {
    courseSubject.close();
  }
}
