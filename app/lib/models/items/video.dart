import 'package:dev_doctor/models/item.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';

import '../part.dart';

enum VideoSource { youtube, url, asset }

class VideoPartItem extends PartItem {
  final VideoSource source;
  final String url;
  final int points;

  VideoPartItem(
      {this.source = VideoSource.url,
      this.points = 1,
      required this.url,
      String name = '',
      String description = '',
      int? index})
      : super(name: name, description: description, index: index);
  @override
  VideoPartItem.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        points = json['points'] ?? 1,
        source = json['source'] != null
            ? EnumToString.fromString(VideoSource.values, json['source']) ?? VideoSource.url
            : VideoSource.url,
        super.fromJson(json);
  Uri getSource(CoursePart part) {
    var uri = part.uri;
    switch (source) {
      case VideoSource.youtube:
        return Uri.https(
          'www.youtube-nocookie.com',
          'embed/${url}',
        );
      case VideoSource.asset:
        return Uri(
            scheme: uri.scheme,
            fragment: uri.fragment,
            host: uri.host,
            pathSegments: [...uri.pathSegments, url]);
      default:
        return Uri.parse(url);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "type": "video",
      "url": url,
      "source": EnumToString.convertToString(source),
      "name": name,
      "description": description,
      "points": points
    };
  }

  VideoPartItem copyWith({String? name, String? description, VideoSource? source, String? url}) =>
      VideoPartItem(
          name: name ?? this.name,
          description: description ?? this.description,
          index: index,
          source: source ?? this.source,
          url: url ?? this.url);

  @override
  IconData get icon => Icons.play_arrow_outlined;
}
