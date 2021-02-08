import 'package:dev_doctor/models/items/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VideoPartItemPage extends StatefulWidget {
  final VideoPartItem item;

  const VideoPartItemPage({Key key, this.item}) : super(key: key);
  @override
  _VideoPartItemPageState createState() => _VideoPartItemPageState();
}

class _VideoPartItemPageState extends State<VideoPartItemPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: InAppWebView(
        initialUrl: Uri.https('www.youtube-nocookie.com', 'embed/${widget.item.url}').toString(),
      ),
    ));
  }
}
