import 'package:dev_doctor/courses/part/bloc.dart';
import 'package:dev_doctor/courses/part/quiz.dart';
import 'package:dev_doctor/courses/part/text.dart';
import 'package:dev_doctor/editor/part.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/item.dart';
import 'package:dev_doctor/models/items/quiz.dart';
import 'package:dev_doctor/models/items/text.dart';
import 'package:dev_doctor/models/items/video.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:dev_doctor/courses/part/video.dart'
    if (dart.library.html) 'package:dev_doctor/courses/part/video_web.dart'
    if (dart.library.io) 'package:dev_doctor/courses/part/video_mobile.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'bloc.dart';
import 'layout.dart';
import 'module.dart';

class PartItemPage extends StatefulWidget {
  final PartItem model;
  final int itemId;
  final ServerEditorBloc editorBloc;

  const PartItemPage({Key key, this.model, this.itemId, this.editorBloc}) : super(key: key);

  @override
  _PartItemPageState createState() => _PartItemPageState();
}

class _PartItemPageState extends State<PartItemPage> {
  CoursePartBloc bloc;
  GlobalKey _itemKey = GlobalKey();
  ScrollController _detailsScrollController = ScrollController();
  ScrollController _itemScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _buildBloc();
  }

  @override
  void didUpdateWidget(PartItemPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  Future<void> _buildBloc() async {
    if (widget.editorBloc != null) bloc = EditorPartModule.to.get<CoursePartBloc>();
    bloc = CoursePartModule.to.get<CoursePartBloc>();
    await bloc?.fetchFromParams(editorBloc: widget.editorBloc);
  }

  @override
  Widget build(BuildContext context) {
    return PartItemLayout(
        editorBloc: widget.editorBloc,
        itemId: widget.itemId,
        child: Container(
            child: StreamBuilder<CoursePart>(
                stream: bloc.coursePart,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                  var part = snapshot.data;
                  if (part.items.isEmpty) {
                    return Center(child: Text('course.part.empty'.tr()));
                  }
                  var itemId = widget.itemId;
                  if (itemId < 0) itemId = 0;
                  if (itemId >= part.items.length) itemId = part.items.length - 1;
                  var item = part.items[itemId];
                  if (item == null) return Center(child: CircularProgressIndicator());
                  Widget itemWidget = Text("Not supported!");
                  if (item is VideoPartItem)
                    itemWidget = VideoPartItemPage(
                        item: item, key: _itemKey, editorBloc: widget.editorBloc, itemId: itemId);
                  if (item is TextPartItem)
                    itemWidget = TextPartItemPage(
                        item: item, key: _itemKey, editorBloc: widget.editorBloc, itemId: itemId);
                  if (item is QuizPartItem)
                    itemWidget = QuizPartItemPage(
                        item: item, key: _itemKey, editorBloc: widget.editorBloc, itemId: itemId);
                  final itemBuilder = Builder(builder: (context) => itemWidget);
                  return LayoutBuilder(builder: (context, constraints) {
                    var itemCard = Scrollbar(
                        controller: _detailsScrollController,
                        child: SingleChildScrollView(
                            controller: _detailsScrollController,
                            child: Card(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(64.0),
                                        child: itemBuilder)))));
                    var detailsCard = Scrollbar(
                        controller: _itemScrollController,
                        child: SingleChildScrollView(
                            controller: _itemScrollController,
                            child: Card(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                    padding: const EdgeInsets.all(64.0),
                                    child: Row(children: [
                                      Expanded(
                                          child: Column(children: [
                                        Text(item.name ?? '',
                                            style: Theme.of(context).textTheme.headline5),
                                        Text(item.description ?? '')
                                      ])),
                                      if (widget.editorBloc != null)
                                        IconButton(
                                          icon: Icon(Icons.edit_outlined),
                                          onPressed: () => Modular.to.pushNamed(Uri(pathSegments: [
                                            '',
                                            'editor',
                                            'course',
                                            'item',
                                            'edit'
                                          ], queryParameters: {
                                            ...Modular.args.queryParams
                                          }).toString()),
                                        )
                                    ])))));
                    if (MediaQuery.of(context).size.width > 1000)
                      return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        Expanded(child: detailsCard),
                        Expanded(flex: 3, child: itemCard)
                      ]);
                    else
                      return Scrollbar(
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [detailsCard, itemCard])));
                  });
                })));
  }
}
