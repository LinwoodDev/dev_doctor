import 'package:flutter/foundation.dart';

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
}
