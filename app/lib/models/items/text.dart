import 'package:dev_doctor/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';

class TextPartItem extends PartItem {
  final String text;
  final int points;

  TextPartItem(
      {this.points = 1, this.text = "", String name = '', String description = '', int? index})
      : super(name: name, description: description, index: index);
  @override
  TextPartItem.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        points = json['points'] ?? 1,
        super.fromJson(json);

  Map<String, dynamic> toJson() =>
      {"type": "text", "text": text, "name": name, "description": description, "points": points};

  TextPartItem copyWith({String? text, String? name, String? description, int? points}) =>
      TextPartItem(
          text: text ?? this.text,
          description: description ?? this.description,
          index: index,
          name: name ?? this.name,
          points: points ?? this.points);

  @override
  IconData get icon => Icons.subject_outlined;
}
