import 'package:dev_doctor/models/server.dart';

import 'course.dart';
import 'item.dart';
import 'items/quiz.dart';
import 'items/text.dart';
import 'items/video.dart';

class Part {
  final Course course;
  final String name;
  final String description;
  final String slug;
  final List<PartItem> items;

  Part({this.name, this.description, this.slug, this.items, this.course});
  Part.fromJson(Map<String, dynamic> json)
      : course = json['course'],
        description = json['description'],
        name = json['name'],
        slug = json['slug'],
        items = (json['items'] as List<Map<String, dynamic>>).map<PartItem>((item) {
          switch (item['type']) {
            case 'text':
              return TextPartItem.fromJson(item);
            case 'video':
              return VideoPartItem.fromJson(item);
            case 'quiz':
              return QuizPartItem.fromJson(item);
            default:
              return null;
          }
        });

  CoursesServer get server => course.server;
}
