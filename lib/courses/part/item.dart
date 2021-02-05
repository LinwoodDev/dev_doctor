import 'package:dev_doctor/courses/part/quiz.dart';
import 'package:dev_doctor/courses/part/text.dart';
import 'package:dev_doctor/models/item.dart';
import 'package:dev_doctor/models/items/quiz.dart';
import 'package:dev_doctor/models/items/text.dart';
import 'package:dev_doctor/models/items/video.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:dev_doctor/courses/part/video.dart'
    if (dart.library.html) 'package:dev_doctor/courses/part/video_web.dart'
    if (dart.library.io) 'package:dev_doctor/courses/part/video_mobile.dart';

class PartItemPage extends StatefulWidget {
  final PartItem model;
  final int itemId;

  const PartItemPage({Key key, this.model, this.itemId}) : super(key: key);

  @override
  _PartItemPageState createState() => _PartItemPageState();
}

class _PartItemPageState extends State<PartItemPage> {
  CoursePart part;
  Future<PartItem> _buildFuture() async {
    PartItem item = widget.model;
    if (shouldRedirect()) {
      return null;
    }
    if (item == null) {
      var server = await CoursesServer.fetch(index: widget.serverId);
      var course = await server.fetchCourse(widget.courseId);
      part = await course.fetchPart(widget.partId);
      return part.items[widget.itemId];
    }
    return item;
  }

  void initState() {
    redirect();
    super.initState();
  }

  void redirect() async {
    if (shouldRedirect())
      await Modular.to.pushReplacementNamed('/courses/' +
          (widget.serverId?.toString() ?? '0') +
          "/" +
          (widget.courseId?.toString() ?? '0') +
          "/start/" +
          (widget.partId?.toString() ?? '0') +
          "/" +
          (widget.itemId?.toString() ?? '0'));
  }

  bool shouldRedirect() =>
      widget.serverId == null ||
      widget.courseId == null ||
      widget.partId == null ||
      widget.itemId == null;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<PartItem>(
            future: _buildFuture(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                  var item = snapshot.data;
                  if (item == null) return Center(child: CircularProgressIndicator());
                  return Scaffold(
                      resizeToAvoidBottomInset: false,
                      appBar: AppBar(title: Text(part.name)),
                      body: Scrollbar(child: LayoutBuilder(builder: (context, constraints) {
                        var itemCard = Expanded(
                            flex: 3,
                            child: Card(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(64.0),
                                        child: Builder(builder: (context) {
                                          if (item is VideoPartItem)
                                            return VideoPartItemPage(item: item);
                                          if (item is TextPartItem)
                                            return TextPartItemPage(item: item);
                                          if (item is QuizPartItem)
                                            return QuizPartItemPage(item: item);
                                          return Text("Not supported!");
                                        })))));
                        var detailsCard = Expanded(
                            child: Card(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      })));
              }
            }));
  }
}
