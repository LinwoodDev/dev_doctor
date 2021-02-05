import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class CoursePartBloc extends Disposable {
  BehaviorSubject<CoursePart> part$ = BehaviorSubject<CoursePart>();
  CoursePartBloc({int serverId, int courseId, int partId}) {
    CoursesServer.fetch(index: serverId).then((value) => value
        .fetchCourse(courseId)
        .then((value) => value.fetchPart(partId).then((value) => part$.add(value))));
  }

  @override
  void dispose() {
    part$.close();
  }
}
