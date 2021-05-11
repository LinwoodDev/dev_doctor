import 'dart:io';

import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/items/video.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'bloc.dart';
import 'module.dart';
import 'video.dart' as defaultVideo;

class VideoPartItemPage extends StatefulWidget {
  final VideoPartItem item;
  final ServerEditorBloc? editorBloc;
  final CoursePart part;
  final int itemId;

  const VideoPartItemPage(
      {Key? key, required this.item, required this.part, this.editorBloc, required this.itemId})
      : super(key: key);
  @override
  _VideoPartItemPageState createState() => _VideoPartItemPageState();
}

class _VideoPartItemPageState extends State<VideoPartItemPage> {
  InAppWebViewController? webView;
  late bool isEmpty;
  @override
  void initState() {
    isEmpty = widget.item.url.isEmpty;
    super.initState();
    if (widget.editorBloc == null && !widget.part.itemVisited(widget.itemId)) {
      var bloc = CoursePartModule.to.get<CoursePartBloc>();
      widget.part.setItemPoints(widget.itemId, 1);
      bloc.partSubject.add(widget.part);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS)
      return Row(children: [
        Expanded(
            child: Container(
                child: isEmpty
                    ? Center(child: Text('course.video.empty').tr())
                    : SafeArea(
                        child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: InAppWebView(
                                onWebViewCreated: (InAppWebViewController controller) {
                                  webView = controller;
                                },
                                initialUrlRequest:
                                    URLRequest(url: widget.item.getSource(widget.part))))))),
        if (widget.editorBloc != null)
          IconButton(
              tooltip: "edit".tr(),
              onPressed: () => Modular.to.push(MaterialPageRoute(
                  builder: (context) => defaultVideo.VideoPartItemEditorPage(
                      editorBloc: widget.editorBloc, item: widget.item, itemId: widget.itemId))),
              icon: Icon(Icons.edit_outlined))
      ]);
    else
      return defaultVideo.VideoPartItemPage(
          part: widget.part,
          itemId: widget.itemId,
          item: widget.item,
          editorBloc: widget.editorBloc);
  }
}
