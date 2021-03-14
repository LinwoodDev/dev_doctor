import 'package:dev_doctor/editor/bloc/course.dart';
import 'package:dev_doctor/editor/bloc/server.dart';
import 'package:dev_doctor/editor/services/course.dart';
import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/server.dart';

class ServerEditorService {
  ServerEditorBloc bloc;

  ServerEditorService(this.bloc);
  factory ServerEditorService.fromKey(int key) =>
      ServerEditorService(ServerEditorBloc.fromKey(key));

  CourseEditorBloc createCourse(String slug) {
    if (getCourse(slug) != null) return null;
    var course = CourseEditorBloc(Course(name: slug, slug: slug));
    var courses = List<CourseEditorBloc>.from(bloc.courses);
    courses.add(course);
    bloc = bloc.copyWith(courses: courses);
    save();
    return course;
  }

  void updateCourse(String slug, CourseEditorBloc courseBloc) {
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
  int get key => bloc.key;
}
