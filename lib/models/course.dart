import 'package:dev_doctor/loader.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:flutter/foundation.dart';
import 'part.dart';

@immutable
class Course {
  final CoursesServer server;
  final String slug;
  final String name;
  final String description;
  final String icon;
  final String author;
  final bool installed;
  final String body;
  final String lang;
  final int index;
  final List<String> parts;

  Course(
      {this.slug,
      this.name,
      this.index,
      this.description,
      this.icon,
      this.author,
      this.installed,
      this.body,
      this.lang,
      this.parts,
      this.server});
  Course.fromJson(Map<String, dynamic> json)
      : server = json['server'],
        slug = json['slug'],
        name = json['name'],
        description = json['description'],
        icon = json['icon'],
        author = json['author'],
        body = json['body'],
        index = json['index'],
        installed = json['installed'],
        lang = json['lang'],
        parts = json['parts'];

  get url => server.url + "/" + slug;

  Future<List<CoursePart>> fetchParts() async =>
      Future.wait(parts.asMap().map((index, value) => MapEntry(index, fetchPart(index))).values);

  Future<CoursePart> fetchPart(int index) async {
    var part = parts[index];
    var data = await loadFile("${server.url}/$slug/$part/config", type: server.type);
    //data['items'] = yamlListToJson(data['items']).toList();
    data['course'] = this;
    data['slug'] = part;
    return CoursePart.fromJson(data);
  }
}
