import 'package:dev_doctor/editor/bloc/course.dart';
import 'package:dev_doctor/models/course.dart';

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

  Course get course => bloc.course;
  /* set course(Course value) => bloc = bloc.copyWith(course: value)..save();

  CoursePart createPart(String name) {
    if (getCourse(name) != null) return null;
    var course = CoursePart(Course(name: slug, slug: slug));
    var courses = List<CourseEditorBloc>.from(bloc.courses);
    courses.add(course);
    bloc = bloc.copyWith(courses: courses);
    save();
    return course;
  }

  void updatePart(String slug, CoursePart courseBloc) {
    var current = List<CourseEditorBloc>.from(courses);
    current[bloc.server.courses.indexOf(slug)] = courseBloc;
    bloc = bloc.copyWith(courses: current);
  }

  CourseEditorBloc getCourseBloc(String slug) {
    return bloc.courses.firstWhere((e) => e.course.slug == slug);
  }

  CourseEditorService getCourse(String slug) => CourseEditorService.fromSlug(this, slug);

  void deleteCourse(String slug) {
    var courses = List<CourseEditorBloc>.from(bloc.courses);
    courses = courses.where((element) => element.course.slug == slug);
    bloc = bloc.copyWith(courses: courses);
    save();
  }

  void save() {
    bloc.save();
  }

  CoursesServer get server => bloc.server;
  set server(CoursesServer value) => bloc = bloc.copyWith(server: value)..save();
  String get note => bloc.note;
  set note(String value) => bloc = bloc.copyWith(note: bloc.note)..save();
  List<CourseEditorBloc> get courses => bloc.courses;
  int get key => bloc.key; */
}
