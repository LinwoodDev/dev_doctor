import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/part.dart';

class CourseEditorBloc {
  final Course course;
  final List<CoursePart> parts;

  CourseEditorBloc(this.course, {List<CoursePart> parts = const []})
      : parts = List<CoursePart>.unmodifiable(parts);

  CourseEditorBloc.fromJson(Map<String, dynamic> json)
      : course = Course.fromJson(json['course']),
        parts = List<CoursePart>.unmodifiable((json['parts'] as List<dynamic> ?? [])
            .map((e) => CoursePart.fromJson(e))
            .toList(growable: false));
  Map<String, dynamic> toJson() =>
      {"course": course.toJson(), "parts": parts.map((e) => e.toJson()).toList()};
  CourseEditorBloc copyWith({Course course, List<CoursePart> parts}) =>
      CourseEditorBloc(course ?? this.course, parts: parts ?? this.parts);
}
