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

  void initState() {
    bloc = CoursePartModule.to.get<CoursePartBloc>();
    super.initState();
  }

  bool shouldRedirect() => widget.itemId == null;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<CoursePart>(
            stream: bloc.coursePart,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              var part = snapshot.data;
              var item = part.items[widget.itemId];
              if (item == null) return Center(child: CircularProgressIndicator());
              return Scrollbar(child: LayoutBuilder(builder: (context, constraints) {
                var itemCard = Expanded(
                    flex: 3,
                    child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Container(
                            child: Padding(
                                padding: const EdgeInsets.all(64.0),
                                child: Builder(builder: (context) {
                                  if (item is VideoPartItem) return VideoPartItemPage(item: item);
                                  if (item is TextPartItem) return TextPartItemPage(item: item);
                                  if (item is QuizPartItem) return QuizPartItemPage(item: item);
                                  return Text("Not supported!");
                                })))));
                var detailsCard = Expanded(
                    child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                            padding: const EdgeInsets.all(64.0),
                            child: Column(children: [
                              Text(item.name, style: Theme.of(context).textTheme.headline5),
                              Text(item.description ?? '')
                            ]))));
                if (MediaQuery.of(context).size.width > 1000)
                  return Row(children: [detailsCard, itemCard]);
                else
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [detailsCard, itemCard]);
              }));
            }));
  }
}
