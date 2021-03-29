import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/items/video.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class VideoPartItemPage extends StatelessWidget {
  final VideoPartItem item;
  final ServerEditorBloc editorBloc;
  final int itemId;

  const VideoPartItemPage({Key key, this.item, this.editorBloc, this.itemId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Container(
              child: Center(
                  child: item.source == null || item.url == null
                      ? Text('course.video.empty').tr()
                      : ElevatedButton.icon(
                          icon: Icon(Icons.play_circle_outline_outlined),
                          label: Text("course.video.open".tr().toUpperCase()),
                          onPressed: () => launch(item.src),
                        )))),
      if (editorBloc != null) IconButton(onPressed: () {}, icon: Icon(Icons.edit_outlined))
    ]);
  }
}

class VideoPartItemEditorPage extends StatefulWidget {
  final VideoPartItem item;
  final ServerEditorBloc editorBloc;
  final int itemId;

  const VideoPartItemEditorPage({Key key, this.item, this.editorBloc, this.itemId})
      : super(key: key);

  @override
  _VideoPartItemEditorPageState createState() => _VideoPartItemEditorPageState();
}

class _VideoPartItemEditorPageState extends State<VideoPartItemEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: 'course.video.editor.title'.tr()), body: ListView(children: []));
  }
}
