import 'package:dev_doctor/models/article.dart';
import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:hive/hive.dart';

import 'course.dart';

class ServerEditorBloc extends HiveObject {
  CoursesServer _server;
  String? note;
  final List<CourseEditorBloc> _courses;
  final List<Article> _articles;

  CoursesServer get server =>
      _server.copyWith(courses: _courses.map((e) => e.course.slug).toList());
  set server(CoursesServer value) => _server = value;

  List<CourseEditorBloc> get courses => List.unmodifiable(_courses);

  ServerEditorBloc(
      {List<CourseEditorBloc> courses = const [],
      this.note,
      required String name,
      List<Article> articles = const []})
      : _server = CoursesServer(name: name, courses: []),
        _courses = List<CourseEditorBloc>.from(courses),
        _articles = List<Article>.from(articles);
  ServerEditorBloc.fromJson(Map<String, dynamic> json)
      : _server = CoursesServer.fromJson(Map<String, dynamic>.from(json['server'] ?? {})),
        note = json['note'],
        _courses = List<CourseEditorBloc>.from((json['courses'] ?? [])
            .map((e) => CourseEditorBloc.fromJson(Map<String, dynamic>.from(e)))
            .toList()),
        _articles = List<Article>.from((json['articles'] as List<dynamic>? ?? [])
            .map((e) => Article.fromJson(Map<String, dynamic>.from(e)))
            .toList());
  factory ServerEditorBloc.fromKey(int? key) => Hive.box<ServerEditorBloc>('editor').get(key)!;
  Map<String, dynamic> toJson(int? apiVersion) => {
        "server": server.toJson(),
        "note": note,
        "courses": _courses.map((e) => e.toJson(apiVersion)).toList()
      };

  List<String> getCourseSlugs() => _courses.map((e) => e.course.slug).toList();
  CourseEditorBloc? createCourse(String slug) {
    if (getCourseSlugs().contains(slug)) return null;
    var courseBloc = CourseEditorBloc(Course(name: slug, slug: slug, parts: []));
    _courses.add(courseBloc);
    return courseBloc;
  }

  void deleteCourse(String slug) => _courses.removeWhere((element) => element.course.slug == slug);

  CourseEditorBloc getCourse(String slug) =>
      _courses.firstWhere((element) => element.course.slug == slug);
  bool hasCourse(String slug) =>
      _courses.where((element) => element.course.slug == slug).isNotEmpty;
  CourseEditorBloc changeCourseSlug(String oldSlug, String newSlug) {
    var courseBloc = getCourse(oldSlug);
    var course = courseBloc.course.copyWith(slug: newSlug);
    var newBloc = CourseEditorBloc(course, parts: courseBloc.parts);
    _courses[_courses.indexOf(courseBloc)] = newBloc;
    return newBloc;
  }

  List<String> getArticlesSlug() => _articles.map((e) => e.slug).toList();
  Article? createArticle(String slug) {
    if (getArticlesSlug().contains(slug)) return null;
    var part = Article(title: slug, slug: slug);
    _articles.add(part);
    return part;
  }

  bool hasArticle(String slug) => _articles.where((element) => element.slug == slug).isNotEmpty;

  void deleteArticle(String? slug) => _articles.removeWhere((element) => element.slug == slug);

  void updateArticle(Article article) {
    var index = _articles.indexWhere((element) => article.slug == element.slug);
    _articles[index] = article;
  }

  Article changeArticleSlug(String oldSlug, String newSlug) {
    var part = getArticle(oldSlug);
    var newBloc = part.copyWith(slug: newSlug);
    _articles[_articles.indexWhere((element) => element.slug == oldSlug)] = newBloc;
    return newBloc;
  }

  Article getArticle(String slug) => _articles.firstWhere((element) => element.slug == slug);
}

class ServerEditorBlocAdapter extends TypeAdapter<ServerEditorBloc> {
  final int? apiVersion;

  ServerEditorBlocAdapter({this.apiVersion});
  @override
  ServerEditorBloc read(BinaryReader reader) =>
      ServerEditorBloc.fromJson(Map<String, dynamic>.from(reader.read()));

  @override
  final typeId = 2;

  @override
  void write(BinaryWriter writer, ServerEditorBloc obj) {
    writer.write(obj.toJson(apiVersion));
  }
}
