import 'package:dev_doctor/models/items/video.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class VideoPartItemPage extends StatelessWidget {
  final VideoPartItem item;

  const VideoPartItemPage({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: ElevatedButton.icon(
      icon: Icon(Icons.play_circle_outline_outlined),
      label: Text("course.video.open".tr().toUpperCase()),
      onPressed: () => launch(item.src),
    )));
  }
}
