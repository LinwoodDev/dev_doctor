import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

import 'course.dart';

@immutable
class CoursesServer {
  final String name;
  final String url;
  final List<String> courses;

  CoursesServer({this.name, this.url, this.courses});
  CoursesServer.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = json['url'],
        courses = json['courses'];

  static Future<CoursesServer> fetch(String url) async {
    var response = await http.get("$url/config.yml");
    var data = loadYaml(response.body);
    data['url'] = url;
    return CoursesServer.fromJson(data);
  }

  Future<List<Course>> fetchCourses() => Future.wait(
      courses.asMap().map((index, value) => MapEntry(index, fetchCourse(index))).values);

  Future<Course> fetchCourse(int index) async {
    var course = courses[index];
    var response = await http.get("$url/$course/config.yml");
    var data = loadYaml(response.body);
    data['server'] = this;
    data['slug'] = courses;
    return Course.fromJson(data);
  }
}
