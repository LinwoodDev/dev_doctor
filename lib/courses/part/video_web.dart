// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:dev_doctor/models/items/video.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class VideoPartItemPage extends StatefulWidget {
  final VideoPartItem item;
  final bool editing;

  const VideoPartItemPage({Key key, this.item, this.editing}) : super(key: key);
  @override
  _VideoPartItemPageState createState() => _VideoPartItemPageState();
}

class _VideoPartItemPageState extends State<VideoPartItemPage> {
  IFrameElement _iframeElement;
  Widget _iframeWidget;
  bool isEmpty;
  @override
  void initState() {
    super.initState();
    isEmpty = widget.item.source == null || widget.item.url == null;
    if (!isEmpty) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          child: widget.item.source == null || widget.item.url == null
              ? Center(child: Text('course.video.empty').tr())
              : AspectRatio(
                  child: _iframeWidget,
                  aspectRatio: 16 / 9,
                )),
      if (widget.editing) IconButton(onPressed: () {}, icon: Icon(Icons.edit_outlined))
    ]);
  }
}
