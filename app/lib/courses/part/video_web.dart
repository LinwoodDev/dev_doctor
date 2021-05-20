// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:dev_doctor/models/part.dart';

import '../../platform_view_stub.dart' if (dart.library.html) 'dart:ui' as ui;

import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/items/video.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'bloc.dart';
import 'module.dart';
import 'video.dart' as defaultVideo;

class VideoPartItemPage extends StatefulWidget {
  final VideoPartItem item;
  final CoursePart part;
  final ServerEditorBloc? editorBloc;
  final int itemId;

  const VideoPartItemPage(
      {Key? key, required this.item, this.editorBloc, required this.itemId, required this.part})
      : super(key: key);
  @override
  _VideoPartItemPageState createState() => _VideoPartItemPageState();
}

class _VideoPartItemPageState extends State<VideoPartItemPage> {
  late IFrameElement _iframeElement;
  Widget? _iframeWidget;
  late bool isEmpty;
  @override
  void initState() {
    super.initState();
    isEmpty = widget.item.url.isEmpty;
    if (!isEmpty) {
      _iframeElement = IFrameElement();

      _iframeElement.height = '500';
      _iframeElement.width = '500';

      _iframeElement.src = widget.item.getSource(widget.part).toString();
      //_iframeElement.allowFullscreen = true;
      _iframeElement.style.border = 'none';
      _iframeElement.allowFullscreen = true;

      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory('iframeElement', (int viewId) => _iframeElement);

      _iframeWidget = HtmlElementView(
        key: UniqueKey(),
        viewType: 'iframeElement',
      );
    }
    if (widget.editorBloc == null && !widget.part.itemVisited(widget.itemId)) {
      var bloc = CoursePartModule.to.get<CoursePartBloc>();
      widget.part.setItemPoints(widget.itemId, 1);
      bloc.partSubject.add(widget.part);
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
          part: widget.part,
          editorBloc: widget.editorBloc,
          item: widget.item,
          itemId: widget.itemId);
    return Row(children: [
      Expanded(
          child: Container(
              child: widget.item.url.isEmpty
                  ? Center(child: Text('course.video.empty').tr())
                  : AspectRatio(
                      child: _iframeWidget!,
                      aspectRatio: 16 / 9,
                    ))),
      if (widget.editorBloc != null)
        IconButton(
            tooltip: "edit".tr(),
            onPressed: () => Modular.to.push(MaterialPageRoute(
                builder: (context) => defaultVideo.VideoPartItemEditorPage(
                    editorBloc: widget.editorBloc, item: widget.item, itemId: widget.itemId))),
            icon: Icon(Icons.edit_outlined))
    ]);
  }
}
