import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:hive/hive.dart';

class CourseEditorBloc {
  Course _course;
  final List<CoursePart> _parts;
  List<CoursePart> get parts => List.unmodifiable(_parts);

  CourseEditorBloc(this._course, {List<CoursePart> parts = const []})
      : _parts = List<CoursePart>.from(parts ?? []);

  CourseEditorBloc.fromJson(Map<String, dynamic> json)
      : _course = Course.fromJson(Map<String, dynamic>.from(json['course'] ?? {})),
        _parts = List<CoursePart>.from((json['parts'] as List<dynamic> ?? [])
                .map((e) => CoursePart.fromJson(Map<String, dynamic>.from(e) ?? {}))
                .toList() ??
            []);
  Course get course => _course;
  set course(Course value) {
    if (_course.slug == value.slug) _course = value;
  }

  Map<String, dynamic> toJson(int apiVersion) =>
      {"course": _course.toJson(apiVersion), "parts": _parts.map((e) => e.toJson()).toList()};

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

class CourseEditorBlocAdapter extends TypeAdapter<CourseEditorBloc> {
  final int apiVersion;

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
