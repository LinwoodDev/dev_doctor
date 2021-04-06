import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class CoursePartBloc extends Disposable {
  BehaviorSubject<CoursePart> coursePart = BehaviorSubject<CoursePart>();
  String? course, part;
  bool _error = false;

  bool get hasError => _error;
  CoursePartBloc() {}
  Future<void> fetch(
      {ServerEditorBloc? editorBloc,
      String? server,
      int? serverId,
      String? course,
      int? courseId,
      String? part,
      int? partId}) async {
    reset();
    try {
      var currentServer = editorBloc != null
          ? editorBloc.server
          : await CoursesServer.fetch(index: serverId, url: server);
      if (courseId != null) course = currentServer?.courses[courseId];
      this.course = course;
      var currentCourse = editorBloc != null
          ? editorBloc.getCourse(course!).course
          : await currentServer?.fetchCourse(course);
      if (partId != null) part = currentCourse?.parts[partId];
      this.part = part;
      var current = editorBloc != null
          ? editorBloc.getCourse(course!).getCoursePart(part)
          : await currentCourse?.fetchPart(part);
      if (current != null) coursePart.add(current);
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
        partId: int.tryParse(params['partId'] ?? ''),
        serverId: int.tryParse(params['serverId'] ?? ''),
        part: params['part']);
  }

  void reset() {
    coursePart = BehaviorSubject<CoursePart>();
    _error = false;
  }

  @override
  void dispose() {
    coursePart.close();
  }
}
