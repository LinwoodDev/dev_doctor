// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import '../../platform_view_stub.dart' if (dart.library.html) 'dart:ui' as ui;

import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/items/video.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'video.dart' as defaultVideo;

class VideoPartItemPage extends StatefulWidget {
  final VideoPartItem? item;
  final ServerEditorBloc? editorBloc;
  final int? itemId;

  const VideoPartItemPage({Key? key, this.item, this.editorBloc, this.itemId}) : super(key: key);
  @override
  _VideoPartItemPageState createState() => _VideoPartItemPageState();
}

class _VideoPartItemPageState extends State<VideoPartItemPage> {
  IFrameElement? _iframeElement;
  Widget? _iframeWidget;
  late bool isEmpty;
  @override
  void initState() {
    super.initState();
    isEmpty = widget.item!.source == null || widget.item!.url == null;
    if (!isEmpty) {
      _iframeElement = IFrameElement();

      _iframeElement!.height = '500';
      _iframeElement!.width = '500';

      _iframeElement!.src = widget.item!.src;
      //_iframeElement.allowFullscreen = true;
      _iframeElement!.style.border = 'none';

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
  void didUpdateWidget(covariant VideoPartItemPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.editorBloc != null)
      return defaultVideo.VideoPartItemPage(
          editorBloc: widget.editorBloc, item: widget.item, itemId: widget.itemId);
    return Row(children: [
      Expanded(
          child: Container(
              child: widget.item!.source == null || widget.item!.url == null
                  ? Center(child: Text('course.video.empty').tr())
                  : AspectRatio(
                      child: _iframeWidget!,
                      aspectRatio: 16 / 9,
                    ))),
      if (widget.editorBloc != null)
        IconButton(
            onPressed: () => Modular.to.push(MaterialPageRoute(
                builder: (context) => defaultVideo.VideoPartItemEditorPage(
                    editorBloc: widget.editorBloc, item: widget.item, itemId: widget.itemId))),
            icon: Icon(Icons.edit_outlined))
    ]);
  }
}
