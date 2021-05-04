import 'package:dev_doctor/courses/part/bloc.dart';
import 'package:dev_doctor/editor/part.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/item.dart';
import 'package:dev_doctor/models/items/video.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class VideoPartItemPage extends StatefulWidget {
  final VideoPartItem item;
  final ServerEditorBloc? editorBloc;
  final int itemId;
  final CoursePart part;

  const VideoPartItemPage(
      {Key? key, required this.item, this.editorBloc, required this.itemId, required this.part})
      : super(key: key);

  @override
  _VideoPartItemPageState createState() => _VideoPartItemPageState();
}

class _VideoPartItemPageState extends State<VideoPartItemPage> {
  @override
  void initState() {
    super.initState();

    widget.part.setItemPoints(widget.itemId, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Container(
              child: Center(
                  child: widget.item!.source == null || widget.item!.url == null
                      ? Text('course.video.empty').tr()
                      : ElevatedButton.icon(
                          icon: Icon(Icons.play_circle_outline_outlined),
                          label: Text("course.video.open".tr().toUpperCase()),
                          onPressed: () => launch(widget.item!.src),
                        )))),
      if (widget.editorBloc != null)
        IconButton(
            tooltip: "edit".tr(),
            onPressed: () => Modular.to.push(MaterialPageRoute(
                builder: (context) => VideoPartItemEditorPage(
                    editorBloc: widget.editorBloc, item: widget.item, itemId: widget.itemId))),
            icon: Icon(Icons.edit_outlined))
    ]);
  }
}

class VideoPartItemEditorPage extends StatefulWidget {
  final VideoPartItem? item;
  final ServerEditorBloc? editorBloc;
  final int? itemId;

  const VideoPartItemEditorPage({Key? key, this.item, this.editorBloc, this.itemId})
      : super(key: key);

  @override
  _VideoPartItemEditorPageState createState() => _VideoPartItemEditorPageState();
}

class _VideoPartItemEditorPageState extends State<VideoPartItemEditorPage> {
  TextEditingController? _urlController;
  VideoSource? source;
  late CoursePartBloc bloc;
  @override
  void initState() {
    bloc = EditorPartModule.to.get<CoursePartBloc>();
    _urlController = TextEditingController(text: widget.item!.url);
    source = widget.item!.source;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: 'course.video.editor.title'.tr()),
        body: Scrollbar(
            child: Center(
                child: Container(
                    constraints: BoxConstraints(maxWidth: 1000),
                    child: ListView(children: [
                      TextField(
                          controller: _urlController,
                          decoration: InputDecoration(
                              labelText: 'course,video.editor.url.label'.tr(),
                              hintText: 'course.video.editor.url.hint'.tr(),
                              suffix: DropdownButton<VideoSource>(
                                  value: source,
                                  onChanged: (VideoSource? newValue) {
                                    setState(() {
                                      source = newValue;
                                    });
                                  },
                                  items: VideoSource.values
                                      .map<DropdownMenuItem<VideoSource>>((VideoSource value) {
                                    return DropdownMenuItem<VideoSource>(
                                        value: value,
                                        child: Text(
                                            'course.video.editor.type.${EnumToString.convertToString(value)}'));
                                  }).toList())))
                    ])))),
        floatingActionButton: FloatingActionButton(
            tooltip: "save".tr(),
            child: Icon(Icons.save_outlined),
            onPressed: () async {
              var bloc = EditorPartModule.to.get<CoursePartBloc>();
              var courseBloc = widget.editorBloc!.getCourse(bloc.course!);
              var coursePart = courseBloc.getCoursePart(bloc.part!);
              var part = coursePart.copyWith(
                  items: List<PartItem>.from(coursePart.items)
                    ..[widget.itemId!] =
                        widget.item!.copyWith(source: source, url: _urlController!.text));
              courseBloc.updateCoursePart(part);
              bloc.partSubject.add(part);
              widget.editorBloc!.save();
            }));
  }
}
