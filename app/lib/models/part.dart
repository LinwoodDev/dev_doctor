import 'package:hive/hive.dart';

import 'server.dart';
import 'course.dart';
import 'item.dart';

class CoursePart {
  final Course? course;
  final String? name;
  final String? description;
  final String slug;
  final List<PartItem> items;

  CoursePart(
      {this.name,
      this.description,
      required this.slug,
      List<PartItem> items = const [],
      this.course})
      : this.items = List<PartItem>.unmodifiable(items);
  CoursePart.fromJson(Map<String, dynamic> json)
      : course = json['course'],
        description = json['description'],
        name = json['name'] ?? '',
        slug = json['slug'],
        items = (json['items'] as List<dynamic>? ?? [])
            .map((item) => PartItemTypesExtension.fromName(item['type'])
                .fromJson(Map<String, dynamic>.from(item)..['part']))
            .toList();
  Map<String, dynamic> toJson(int? apiVersion) => {
        "api-version": apiVersion,
        "description": description,
        "slug": slug,
        "name": name ?? '',
        "items": items.map((e) => e.toJson()).toList()
      };

  Uri getItemUri(int id) {
    Uri serverUri = server!.uri;
    return Uri(
        host: serverUri.host, scheme: serverUri.scheme, pathSegments: ["", slug, id.toString()]);
  }

  int? getItemPoints(int id) => Hive.box<int>('points').get(getItemUri(id).toString());
  void removeItemPoints(int id) => Hive.box<int>('points').delete(getItemUri(id).toString());
  void setItemPoints(int id, int points) =>
      Hive.box<int>('points').put(getItemUri(id).toString(), points);
  bool itemVisited(int id) => Hive.box<int>('points').containsKey(getItemUri(id).toString());
  void setItemVisited(int id) => setItemPoints(id, items[id].points);

  CoursesServer? get server => course?.server;

  Uri get uri {
    Uri serverUri = server!.uri;
    return Uri(host: serverUri.host, scheme: serverUri.scheme, pathSegments: ["", slug]);
  }

  CoursePart copyWith(
          {Course? course,
          String? name,
          String? description,
          String? slug,
          List<PartItem>? items}) =>
      CoursePart(
          course: course ?? this.course,
          description: description ?? this.description,
          items: items ?? this.items,
          name: name ?? this.name,
          slug: slug ?? this.slug);
}
