import 'package:dev_doctor/models/items/quiz.dart';
import 'package:dev_doctor/models/items/text.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:flutter/material.dart';

import 'items/video.dart';

@immutable
abstract class PartItem {
  final String name;
  final String description;
  final int? index;
  final allowReset;

  int get points;

  IconData get icon => Icons.check_box_outline_blank_outlined;

  PartItem(
      {this.allowReset = true, required this.name, required this.description, required this.index});
  PartItem.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        description = json['description'] ?? '',
        index = json['index'],
        allowReset = json['allow-reset'] ?? true;
  Map<String, dynamic> toJson();

  PartItem copyWith({String? name, String? description});
}

enum PartItemTypes { text, video, quiz }

extension PartItemTypesExtension on PartItemTypes {
  PartItem create({String name = '', String description = "", int? index}) {
    switch (this) {
      case PartItemTypes.text:
        return TextPartItem(name: name, description: description, index: index);
      case PartItemTypes.video:
        return VideoPartItem(name: name, description: description, index: index, url: '');
      case PartItemTypes.quiz:
        return QuizPartItem(name: name, description: description, index: index);
    }
  }

  String get name {
    switch (this) {
      case PartItemTypes.text:
        return 'text';
      case PartItemTypes.video:
        return 'video';
      case PartItemTypes.quiz:
        return 'quiz';
    }
  }

  static PartItemTypes fromName(String? name) =>
      PartItemTypes.values.firstWhere((element) => element.name == name);

  PartItem fromJson(Map<String, dynamic> json) {
    switch (this) {
      case PartItemTypes.text:
        return TextPartItem.fromJson(json);
      case PartItemTypes.video:
        return VideoPartItem.fromJson(json);
      case PartItemTypes.quiz:
        return QuizPartItem.fromJson(json);
    }
  }
}
