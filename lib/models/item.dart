import 'package:dev_doctor/models/items/quiz.dart';
import 'package:dev_doctor/models/items/text.dart';
import 'package:flutter/foundation.dart';

import 'items/video.dart';

@immutable
abstract class PartItem {
  final String name;
  final String description;
  final int index;

  PartItem({@required this.name, @required this.description, @required this.index});
  PartItem.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        index = json['index'];
  Map<String, dynamic> toJson();
}

enum PartItemTypes { text, video, quiz }

extension PartItemTypesExtension on PartItemTypes {
  PartItem create({@required String name, String description = "", @required int index}) {
    switch (this) {
      case PartItemTypes.text:
        return TextPartItem(name: name, description: description, index: index);
      case PartItemTypes.video:
        return VideoPartItem(name: name, description: description, index: index);
      case PartItemTypes.quiz:
        return QuizPartItem(name: name, description: description, index: index);
    }
    return null;
  }
}
