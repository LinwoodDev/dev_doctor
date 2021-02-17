import 'package:dev_doctor/models/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../loader.dart';
import 'course.dart';

@immutable
class CoursesServer {
  final String name;
  final String url;
  final String type;
  final String icon;
  final String supportUrl;
  final int index;
  final BackendEntry entry;
  final List<String> courses;
  final String body;

  static Box<String> get _box => Hive.box<String>('servers');

  CoursesServer(
      {this.body,
      this.icon,
      this.index,
      this.name,
      this.url,
      this.courses,
      this.type,
      this.entry,
      this.supportUrl});
  CoursesServer.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = json['url'],
        index = (json['index'] != -1) ? json['index'] : null,
        type = json['type'],
        courses = List<String>.from(json['courses']),
        icon = json['icon'],
        entry = json['entry'],
        body = json['body'],
        supportUrl = json['support_url'];

  bool get added => index != null;

  Future<CoursesServer> add() async => CoursesServer(
      index: await _box.add(url),
      courses: courses,
      name: name,
      type: type,
      url: url,
      icon: icon,
      entry: entry,
      supportUrl: supportUrl);

  Future<CoursesServer> remove() async {
    await _box.delete(index);
    return CoursesServer(
        index: null,
        courses: courses,
        name: name,
        type: type,
        url: url,
        icon: icon,
        entry: entry,
        supportUrl: supportUrl);
  }

  Future<CoursesServer> toggle() => added ? remove() : add();

  static Future<CoursesServer> fetch({String url, int index, BackendEntry entry}) async {
    var data = Map<String, dynamic>();
    try {
      if (index == null) {
        var current = _box.values.toList().indexOf(url);
        if (current != -1) index = _box.keyAt(current);
      } else if (url == null) url = Hive.box<String>('servers').get(index);
      data = await loadFile("$url/config");
    } catch (e) {
      print(e);
    }
    data['entry'] = entry;
    data['url'] = url;
    data['index'] = index;
    print(data);
    return CoursesServer.fromJson(data);
  }

  Future<List<Course>> fetchCourses() => Future.wait(
      courses.asMap().map((index, value) => MapEntry(index, fetchCourse(index))).values);

  Future<Course> fetchCourse(int index) async {
    var course = courses[index];
    var data = await loadFile("$url/$course/config");

    data['server'] = this;
    data['index'] = index;
    data['slug'] = course;
    data['parts'] = data['parts'];
    return Course.fromJson(data);
  }
}
