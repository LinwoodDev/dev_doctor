import 'package:dev_doctor/courses/part/bloc.dart';
import 'package:dev_doctor/courses/part/quiz.dart';
import 'package:dev_doctor/courses/part/text.dart';
import 'package:dev_doctor/models/item.dart';
import 'package:dev_doctor/models/items/quiz.dart';
import 'package:dev_doctor/models/items/text.dart';
import 'package:dev_doctor/models/items/video.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:flutter/material.dart';

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

  const PartItemPage({Key key, this.model, this.itemId}) : super(key: key);

  @override
  _PartItemPageState createState() => _PartItemPageState();
}

class _PartItemPageState extends State<PartItemPage> {
  CoursePartBloc bloc;
  GlobalKey _itemKey = GlobalKey();
  int serverId, partId;
  String course;

  @override
  void initState() {
    _buildBloc();
    super.initState();
  }

  @override
  void didUpdateWidget(PartItemPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  void _buildBloc() {
    var params = Modular.args.queryParams;
    bloc = CoursePartModule.to.get<CoursePartBloc>();
    serverId = int.parse(params['serverId']);
    course = params['course'];
    partId = int.parse(params['partId']);
    bloc?.fetch(serverId: serverId, course: course, partId: partId);
  }

  @override
  Widget build(BuildContext context) {
    return PartItemLayout(
        course: course,
        itemId: widget.itemId,
        partId: partId,
        serverId: serverId,
        child: Container(
            child: StreamBuilder<CoursePart>(
                stream: bloc.coursePart,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                  var part = snapshot.data;
                  var item = part.items[widget.itemId];
                  if (item == null) return Center(child: CircularProgressIndicator());
                  Widget itemWidget = Text("Not supported!");
                  if (item is VideoPartItem)
                    itemWidget = VideoPartItemPage(item: item, key: _itemKey);
                  if (item is TextPartItem)
                    itemWidget = TextPartItemPage(item: item, key: _itemKey);
                  if (item is QuizPartItem)
                    itemWidget = QuizPartItemPage(item: item, key: _itemKey);
                  final itemBuilder = Builder(builder: (context) => itemWidget);
                  return LayoutBuilder(builder: (context, constraints) {
                    var itemCard = Scrollbar(
                        child: SingleChildScrollView(
                            child: Card(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(64.0),
                                        child: itemBuilder)))));
                    var detailsCard = Scrollbar(
                        child: SingleChildScrollView(
                            child: Card(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                    padding: const EdgeInsets.all(64.0),
                                    child: Column(children: [
                                      Text(item.name, style: Theme.of(context).textTheme.headline5),
                                      Text(item.description ?? '')
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
