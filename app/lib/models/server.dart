import 'package:dev_doctor/models/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../loader.dart';
import 'course.dart';

@immutable
class CoursesServer {
  final String name;
  final String? url;
  final String? type;
  final String? icon;
  final String? supportUrl;
  final int? index;
  final BackendEntry? entry;
  final List<String> courses;
  final String? body;

  static Box<String> get _box => Hive.box<String>('servers');

  CoursesServer(
      {this.body,
      this.icon,
      this.index,
      required this.name,
      this.url,
      required this.courses,
      this.type,
      this.entry,
      this.supportUrl});
  CoursesServer.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = json['url'],
        index = (json['index'] != -1) ? json['index'] : null,
        type = json['type'],
        courses = List<String>.from(json['courses'] ?? []),
        icon = json['icon'],
        entry = json['entry'],
        body = json['body'],
        supportUrl = json['support_url'];

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "index": index,
        "courses": courses,
        "icon": icon,
        "entry": entry,
        "body": body,
        "support_url": supportUrl
      };

  bool get added => index != null;

  Future<CoursesServer> add() async => CoursesServer(
      index: await _box.add(url!),
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

  CoursesServer copyWith(
          {String? name,
          String? url,
          String? type,
          String? icon,
          String? supportUrl,
          List<String>? courses,
          String? body}) =>
      CoursesServer(
          name: name ?? this.name,
          body: body ?? this.body,
          courses: courses ?? this.courses,
          entry: entry,
          icon: icon ?? this.icon,
          index: index,
          supportUrl: supportUrl ?? this.supportUrl,
          type: type ?? this.type,
          url: url ?? this.url);

  static Future<CoursesServer?> fetch({String? url, int? index, BackendEntry? entry}) async {
    var data = <String, dynamic>{};
    try {
      if (index == null) {
        var current = _box.values.toList().indexOf(url!);
        if (current != -1) index = _box.keyAt(current);
      } else if (url == null) url = Hive.box<String>('servers').get(index);
      data = await loadFile("$url/config");
    } catch (e) {
      print(e);
      return null;
    }
    data['courses'] = data['courses'] ?? [];
    data['entry'] = entry;
    data['url'] = url;
    data['index'] = index;
    return CoursesServer.fromJson(data);
  }

  Future<List<Course>> fetchCourses() =>
      Future.wait(courses.map((course) => fetchCourse(course))).then((value) async {
        var list = <Course>[];
        value.forEach((element) {
          if (element != null) list.add(element);
        });
        return list;
      });

  Future<Course?> fetchCourse(String? course) async {
    try {
      var data = await loadFile("$url/$course/config");

      data['server'] = this;
      data['index'] = index;
      data['slug'] = course;
      data['api-version'] = data['api-version'] ?? 0;
      return Course.fromJson(data);
    } catch (e) {
      print("Error $e");
      return null;
    }
  }
}

class CoursesServerAdapter extends TypeAdapter<CoursesServer> {
  @override
  CoursesServer read(BinaryReader reader) =>
      CoursesServer.fromJson(Map<String, dynamic>.from(reader.read()));

  @override
  final typeId = 0;

  @override
  void write(BinaryWriter writer, CoursesServer obj) => writer.write(obj.toJson());
}
