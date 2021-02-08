import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class CoursePartBloc extends Disposable {
  BehaviorSubject<CoursePart> coursePart = BehaviorSubject<CoursePart>();
  CoursePartBloc() {}
  Future<dynamic> fetch({int serverId, int courseId, int partId}) {
    coursePart = BehaviorSubject<CoursePart>();
    return CoursesServer.fetch(index: serverId).then((value) => value
        .fetchCourse(courseId)
        .then((value) => value.fetchPart(partId).then((value) => coursePart.add(value))));
  }

  @override
  void dispose() {
    coursePart.close();
  }
}
