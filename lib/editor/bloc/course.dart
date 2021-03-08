import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/part.dart';

class CourseEditorBloc {
  final Course course;
  final List<CoursePart> parts;

  CourseEditorBloc(this.course, {this.parts = const []});

  CourseEditorBloc.fromJson(Map<String, dynamic> json)
      : course = Course.fromJson(json['course']),
        parts = (json['parts'] as List<dynamic> ?? []).map((e) => CoursePart.fromJson(e)).toList();
  Map<String, dynamic> toJson() =>
      {"course": course.toJson(), "parts": parts.map((e) => e.toJson()).toList()};
}
