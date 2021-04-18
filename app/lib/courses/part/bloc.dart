import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc.dart';

class CoursePartBloc extends CourseBloc {
  BehaviorSubject<CoursePart> partSubject = BehaviorSubject<CoursePart>();
  String? course, part;
  CoursePartBloc() {}
  Future<void> fetch(
      {ServerEditorBloc? editorBloc,
      String? server,
      int? serverId,
      String? course,
      int? courseId,
      String? part,
      int? partId,
      bool redirectAddServer = true}) async {
    reset();
    try {
      super.fetch(
          editorBloc: editorBloc,
          server: server,
          serverId: serverId,
          course: course,
          courseId: courseId,
          redirectAddServer: redirectAddServer);
      await courseSubject.listen((currentCourse) async {
        if (partId != null) part = currentCourse.parts[partId];
        this.part = part;
        if (part == null) {
          error = true;
          return;
        }
        var current = editorBloc != null
            ? course == null || part == null || editorBloc.hasCourse(course)
                ? null
                : editorBloc.getCourse(course).getCoursePart(part!)
            : await currentCourse.fetchPart(part);
        partSubject.add(current ?? CoursePart(slug: ''));
        if (current == null) error = true;
      }).asFuture();
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
        partId: int.tryParse(params['partId'] ?? ''),
        serverId: int.tryParse(params['serverId'] ?? ''),
        part: params['part']);
  }

  void reset() {
    partSubject = BehaviorSubject<CoursePart>();
    super.reset();
  }

  @override
  void dispose() {
    partSubject.close();
    super.dispose();
  }
}
