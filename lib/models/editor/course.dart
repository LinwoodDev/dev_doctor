import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:hive/hive.dart';

part 'course.g.dart';

@HiveType(typeId: 3)
class CourseEditorBloc extends HiveObject {
  @HiveField(0)
  Course _course;
  @HiveField(1)
  final List<CoursePart> _parts;
  List<CoursePart> get parts => List.unmodifiable(_parts);

  CourseEditorBloc(this._course, {List<CoursePart> parts = const []})
      : _parts = List<CoursePart>.unmodifiable(parts);

  CourseEditorBloc.fromJson(Map<String, dynamic> json)
      : _course = Course.fromJson(json['course']),
        _parts = List<CoursePart>.unmodifiable((json['parts'] as List<dynamic> ?? [])
                .map((e) => CoursePart.fromJson(e))
                .toList(growable: false) ??
            []);
  Course get course => _course;
  set course(Course value) {
    if (_course.slug == value.slug) _course = value;
  }

  Map<String, dynamic> toJson() =>
      {"course": _course.toJson(), "parts": _parts.map((e) => e.toJson()).toList()};

  List<String> getCoursePartSlugs() => _parts.map((e) => e.slug).toList();
  CoursePart createCoursePart(String slug) {
    if (getCoursePartSlugs().contains(slug)) return null;
    var part = CoursePart(name: slug, slug: slug);
    _parts.add(part);
    return part;
  }

  void deleteCoursePart(String slug) => _parts.removeWhere((element) => element.slug == slug);

  CoursePart getCoursePart(String slug) => _parts.firstWhere((element) => element.slug == slug);
}
