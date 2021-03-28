import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class CoursePartBloc extends Disposable {
  BehaviorSubject<CoursePart> coursePart = BehaviorSubject<CoursePart>();
  CoursePartBloc() {}
  Future<void> fetch(
      {String server, int serverId, String course, int courseId, String part, int partId}) async {
    reset();
    var currentServer = await CoursesServer.fetch(index: serverId, url: server);
    print(course);
    if (courseId != null) course = currentServer.courses[courseId];
    print(course);
    var currentCourse = await currentServer.fetchCourse(course);
    if (partId != null) part = currentCourse.parts[partId];
    var currentPart = await currentCourse.fetchPart(partId);
    coursePart.add(currentPart);
  }

  Future<void> fetchFromParams() {
    var params = Modular.args.queryParams;
    print(params);
    return fetch(
        server: params['server'],
        course: params['course'],
        courseId: int.tryParse(params['courseId'] ?? ''),
        partId: int.tryParse(params['partId'] ?? ''),
        serverId: int.tryParse(params['serverId'] ?? ''),
        part: params['part']);
  }

  void reset() => coursePart = BehaviorSubject<CoursePart>();

  @override
  void dispose() {
    coursePart.close();
  }
}
