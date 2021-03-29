import 'dart:io';

import 'package:dev_doctor/models/items/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'video.dart' as defaultVideo;

class VideoPartItemPage extends StatefulWidget {
  final VideoPartItem item;

  const VideoPartItemPage({Key key, this.item}) : super(key: key);
  @override
  _VideoPartItemPageState createState() => _VideoPartItemPageState();
}

class _VideoPartItemPageState extends State<VideoPartItemPage> {
  InAppWebViewController webView;
  bool isEmpty;
  @override
  void initState() {
    isEmpty = widget.item.source == null || widget.item.url == null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS)
      return Container(
          child: isEmpty
              ? Center(child: Text('course.video.empty').tr())
              : SafeArea(
                  child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: InAppWebView(
                        onWebViewCreated: (InAppWebViewController controller) {
                          webView = controller;
                        },
                        initialUrlRequest: URLRequest(url: Uri.parse(widget.item.src)),
                      ))));
    else
      return defaultVideo.VideoPartItemPage(item: widget.item);
  }
}
