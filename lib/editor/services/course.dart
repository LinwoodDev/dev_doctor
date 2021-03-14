import 'package:dev_doctor/editor/bloc/course.dart';

import 'server.dart';

class CourseEditorService {
  CourseEditorBloc bloc;
  ServerEditorService service;

  CourseEditorService(this.bloc, this.service);
  factory CourseEditorService.fromKey(ServerEditorService service, int key) =>
      CourseEditorService(service.bloc.courses[key], service);
  factory CourseEditorService.fromSlug(ServerEditorService service, String slug) =>
      CourseEditorService.fromKey(service, service.bloc.server.courses.indexOf(slug));

  void save() {
    service.updateCourse(bloc.course.slug, bloc);
    service.save();
  }
}
