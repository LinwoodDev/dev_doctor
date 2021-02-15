import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class CoursePartBloc extends Disposable {
  BehaviorSubject<CoursePart> coursePart = BehaviorSubject<CoursePart>();
  CoursePartBloc() {}
  Future<dynamic> fetch({int serverId, int courseId, int partId}) {
    reset();
    return CoursesServer.fetch(index: Hive.box<String>('servers').keyAt(serverId));
  }

  void reset() => coursePart = BehaviorSubject<CoursePart>();

  @override
  void dispose() {
    coursePart.close();
  }
}
