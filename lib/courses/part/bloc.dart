import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class CoursePartBloc extends Disposable {
  BehaviorSubject<CoursePart> coursePart = BehaviorSubject<CoursePart>();
  CoursePartBloc() {}
  Future<dynamic> fetch({int serverId, String course, int partId}) async {
    reset();
    var server = await CoursesServer.fetch(index: serverId);
    var current = await server.fetchCourse(course);
    var part = await current.fetchPart(partId);
    coursePart.add(part);
  }

  void reset() => coursePart = BehaviorSubject<CoursePart>();

  @override
  void dispose() {
    coursePart.close();
  }
}
