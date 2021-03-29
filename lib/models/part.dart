import 'package:dev_doctor/models/server.dart';

import 'course.dart';
import 'item.dart';

class CoursePart {
  final Course course;
  final String name;
  final String description;
  final String slug;
  final List<PartItem> items;

  CoursePart({this.name, this.description, this.slug, this.items = const [], this.course});
  CoursePart.fromJson(Map<String, dynamic> json)
      : course = json['course'],
        description = json['description'],
        name = json['name'] ?? '',
        slug = json['slug'],
        items = (json['items'] as List<dynamic> ?? [])
            .map((item) => PartItemTypesExtension.fromName(item['type'])?.fromJson(item))
            .toList();
  Map<String, dynamic> toJson() => {
        "description": description,
        "slug": slug,
        "name": name ?? '',
        "items": items?.map((e) => e.toJson())?.toList() ?? []
      };

  CoursesServer get server => course.server;

  CoursePart copyWith(
          {Course course, String name, String description, String slug, List<PartItem> items}) =>
      CoursePart(
          course: course ?? this.course,
          description: description ?? this.description,
          items: items ?? this.items,
          name: name ?? this.name,
          slug: slug ?? this.slug);
}
