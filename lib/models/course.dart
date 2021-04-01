import 'package:dev_doctor/loader.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'author.dart';
import 'part.dart';

@immutable
class Course {
  final CoursesServer? server;
  final String slug;
  final String? name;
  final String? description;
  final String? icon;
  final String? supportUrl;
  final Author? author;
  final bool? installed;
  final String? body;
  final String? lang;
  final int? index;
  final List<String> parts;
  final bool? private;

  Course(
      {required this.slug,
      this.name,
      this.index,
      this.description,
      this.icon,
      this.author,
      this.installed,
      this.body,
      this.supportUrl,
      this.lang,
      required this.parts,
      this.server,
      this.private});
  factory Course.fromJson(Map<String, dynamic> json) {
    var apiVersion = json['api-version'];
    if (apiVersion != null) {
      if (apiVersion < 8) {
        json['author'] = <String, dynamic>{
          "name": json['author'],
          "url": json['author_url'],
          "avatar": json['author_avatar']
        };
      }
    }
    return Course(
        server: json['server'],
        slug: json['slug'],
        name: json['name'],
        description: json['description'],
        icon: json['icon'],
        author: Author.fromJson(Map<String, dynamic>.from(json['author'] ?? {})),
        body: json['body'],
        index: json['index'],
        installed: json['installed'],
        lang: json['lang'],
        parts: List<String>.from(json['parts'] ?? []),
        private: json['private'],
        supportUrl: json['support_url']);
  }
  Map<String, dynamic> toJson(int? apiVersion) => {
        "api-version": apiVersion,
        "server": server,
        "slug": slug,
        "name": name,
        "description": description,
        "icon": icon,
        "author": author?.toJson(),
        "body": body,
        "index": index,
        "installed": installed,
        "lang": lang,
        "parts": parts,
        "private": private,
        "support_url": supportUrl
      };

  get url => server!.url! + "/" + slug;

  Future<List<CoursePart>> fetchParts() async =>
      Future.wait(parts.map((part) => fetchPart(part)).toList());

  Future<CoursePart> fetchPart(String? part) async {
    var data = await loadFile("${server!.url}/$slug/$part/config", type: server!.type);
    //data['items'] = yamlListToJson(data['items']).toList();
    data['course'] = this;
    data['slug'] = part;
    return CoursePart.fromJson(data);
  }

  Course copyWith(
          {String? slug,
          String? name,
          String? description,
          String? icon,
          Author? author,
          String? supportUrl,
          bool? installed,
          String? body,
          String? lang,
          List<String>? parts,
          bool? private}) =>
      Course(
          author: author ?? this.author,
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
  final int? apiVersion;

  CourseAdapter({this.apiVersion});

  @override
  Course read(BinaryReader reader) => Course.fromJson(Map<String, dynamic>.from(reader.read()));

  @override
  final typeId = 1;

  @override
  void write(BinaryWriter writer, Course obj) async {
    writer.write(obj.toJson(apiVersion));
  }
}
