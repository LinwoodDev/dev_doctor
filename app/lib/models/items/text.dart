import 'package:dev_doctor/models/item.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TextPartItem extends PartItem {
  final String text;
  @override
  final int points;

  const TextPartItem(
      {this.points = 1,
      this.text = "",
      String name = '',
      String description = '',
      int? index})
      : super(name: name, description: description, index: index);
  @override
  TextPartItem.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        points = json['points'] ?? 1,
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "type": "text",
        "text": text,
        "name": name,
        "description": description,
        "points": points
      };

  @override
  TextPartItem copyWith(
          {String? text, String? name, String? description, int? points}) =>
      TextPartItem(
          text: text ?? this.text,
          description: description ?? this.description,
          index: index,
          name: name ?? this.name,
          points: points ?? this.points);

  @override
  IconData get icon => PhosphorIcons.articleLight;
}
