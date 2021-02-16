// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:dev_doctor/models/items/video.dart';
import 'package:flutter/material.dart';

class VideoPartItemPage extends StatefulWidget {
  final VideoPartItem item;

  const VideoPartItemPage({Key key, this.item}) : super(key: key);
  @override
  _VideoPartItemPageState createState() => _VideoPartItemPageState();
}

class _VideoPartItemPageState extends State<VideoPartItemPage> {
  IFrameElement _iframeElement;
  Widget _iframeWidget;
  @override
  void initState() {
    super.initState();
    _iframeElement = IFrameElement();

    _iframeElement.height = '500';
    _iframeElement.width = '500';

    _iframeElement.src = widget.item.src;
    //_iframeElement.allowFullscreen = true;
    _iframeElement.style.border = 'none';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );

    _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: AspectRatio(
      child: _iframeWidget,
      aspectRatio: 16 / 9,
    ));
  }
}
