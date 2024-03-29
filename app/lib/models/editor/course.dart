import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:hive/hive.dart';

class CourseEditorBloc {
  Course _course;
  final List<CoursePart> _parts;
  List<CoursePart> get parts => List.unmodifiable(_parts);

  CourseEditorBloc(this._course, {List<CoursePart> parts = const []})
      : _parts = List<CoursePart>.from(parts);

  CourseEditorBloc.fromJson(Map<String, dynamic> json)
      : _course =
            Course.fromJson(Map<String, dynamic>.from(json['course'] ?? {})),
        _parts = List<CoursePart>.from((json['parts'] as List<dynamic>? ?? [])
            .map((e) => CoursePart.fromJson(Map<String, dynamic>.from(e)))
            .toList());
  Course get course =>
      _course.copyWith(parts: parts.map((e) => e.slug).toList());
  set course(Course value) {
    if (_course.slug == value.slug) _course = value;
  }

  Map<String, dynamic> toJson(int? apiVersion) => {
        "course": _course.toJson(apiVersion),
        "parts": _parts.map((e) => e.toJson(apiVersion)).toList()
      };

  List<String> getCoursePartSlugs() => _parts.map((e) => e.slug).toList();
  CoursePart? createCoursePart(String slug) {
    if (getCoursePartSlugs().contains(slug)) return null;
    var part = CoursePart(name: slug, slug: slug);
    _parts.add(part);
    return part;
  }

  bool hasCoursePart(String slug) =>
      parts.where((element) => element.slug == slug).isNotEmpty;

  void deleteCoursePart(String? slug) =>
      _parts.removeWhere((element) => element.slug == slug);

  void updateCoursePart(CoursePart part) {
    var index = _parts.indexWhere((element) => part.slug == element.slug);
    _parts[index] = part;
  }

  CoursePart changeCoursePartSlug(String oldSlug, String newSlug) {
    var part = getCoursePart(oldSlug);
    var newBloc = part.copyWith(slug: newSlug);
    _parts[_parts.indexWhere((element) => element.slug == oldSlug)] = newBloc;
    return newBloc;
  }

  CoursePart getCoursePart(String slug) => _parts
      .firstWhere((element) => element.slug == slug)
      .copyWith(course: _course);
}

class CourseEditorBlocAdapter extends TypeAdapter<CourseEditorBloc> {
  final int? apiVersion;

  CourseEditorBlocAdapter({this.apiVersion});
  @override
  CourseEditorBloc read(BinaryReader reader) =>
      CourseEditorBloc.fromJson(Map<String, dynamic>.from(reader.read()));

  @override
  final typeId = 3;

  @override
  void write(BinaryWriter writer, CourseEditorBloc obj) async {
    writer.write(obj.toJson(apiVersion));
  }
}
