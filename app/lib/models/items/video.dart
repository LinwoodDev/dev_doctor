import 'package:dev_doctor/models/item.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';

enum VideoSource { youtube, url }

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
  get src {
    if (source == VideoSource.youtube)
      return Uri.https(
        'www.youtube-nocookie.com',
        'embed/${url}',
      ).toString();
    else
      return url;
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
