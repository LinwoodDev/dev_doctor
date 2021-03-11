import 'package:dev_doctor/editor/bloc/course.dart';
import 'package:dev_doctor/editor/bloc/server.dart';
import 'package:dev_doctor/models/course.dart';

class ServerEditorService {
  ServerEditorBloc bloc;

  ServerEditorService({this.bloc});

  CourseEditorBloc createCourse(String slug) {
    if (getCourse(slug) != null) return null;
    var course = CourseEditorBloc(Course(name: slug, slug: slug));
    var courses = List<CourseEditorBloc>.from(bloc.courses);
    courses.add(course);
    bloc = bloc.copyWith(courses: courses);
    save();
    return course;
  }

  CourseEditorBloc getCourse(String slug) {
    return bloc.courses.firstWhere((e) => e.course.slug == slug);
  }

  void deleteCourse(String slug) {
    var courses = List<CourseEditorBloc>.from(bloc.courses);
    courses = courses.where((element) => element.course.slug == slug);
    bloc = bloc.copyWith(courses: courses);
    save();
  }

  void save() {
    bloc.save();
  }
}
