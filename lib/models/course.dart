import 'package:dev_doctor/loader.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'part.dart';

@immutable
class Course {
  final CoursesServer server;
  final String slug;
  final String name;
  final String description;
  final String icon;
  final String author;
  final String authorUrl;
  final String authorAvatar;
  final String supportUrl;
  final bool installed;
  final String body;
  final String lang;
  final int index;
  final List<String> parts;
  final bool private;

  Course(
      {this.slug,
      this.name,
      this.index,
      this.description,
      this.icon,
      this.author,
      this.authorUrl,
      this.authorAvatar,
      this.installed,
      this.body,
      this.lang,
      this.parts,
      this.supportUrl,
      this.server,
      this.private});
  Course.fromJson(Map<String, dynamic> json)
      : server = json['server'],
        slug = json['slug'],
        name = json['name'],
        description = json['description'],
        icon = json['icon'],
        author = json['author'],
        authorUrl = json['author_url'],
        authorAvatar = json['author_avatar'],
        body = json['body'],
        index = json['index'],
        installed = json['installed'],
        lang = json['lang'],
        parts = List<String>.from(json['parts'] ?? []),
        private = json['private'],
        supportUrl = json['support_url'];
  Map<String, dynamic> toJson() => {
        "server": server,
        "slug": slug,
        "name": name,
        "description": description,
        "icon": icon,
        "author": author,
        "author_url": authorUrl,
        "author_avatar": authorAvatar,
        "body": body,
        "index": index,
        "installed": installed,
        "lang": lang,
        "parts": parts,
        "private": private,
        "support_url": supportUrl
      };

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

  Course copyWith(
          {String slug,
          String name,
          String description,
          String icon,
          String author,
          String authorUrl,
          String authorAvatar,
          String supportUrl,
          bool installed,
          String body,
          String lang,
          List<String> parts,
          bool private}) =>
      Course(
          author: author ?? this.author,
          authorAvatar: authorAvatar ?? this.authorAvatar,
          authorUrl: authorUrl ?? this.authorUrl,
          body: body ?? this.body,
          description: description ?? this.description,
          icon: icon ?? this.icon,
          index: index,
          installed: installed ?? this.installed,
          lang: lang ?? this.lang,
          name: name ?? this.name,
          parts: parts ?? this.parts,
          private: private ?? this.private,
          server: server ?? this.server,
          slug: slug ?? this.slug,
          supportUrl: supportUrl ?? this.supportUrl);
}

class CourseAdapter extends TypeAdapter<Course> {
  @override
  Course read(BinaryReader reader) => Course.fromJson(Map<String, dynamic>.from(reader.read()));

  @override
  final typeId = 1;

  @override
  void write(BinaryWriter writer, Course obj) => writer.write(obj.toJson());
}
