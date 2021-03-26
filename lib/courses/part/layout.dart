import 'package:dev_doctor/courses/drawer.dart';
import 'package:dev_doctor/models/items/quiz.dart';
import 'package:dev_doctor/models/items/text.dart';
import 'package:dev_doctor/models/items/video.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'bloc.dart';
import 'module.dart';

class PartItemLayout extends StatefulWidget {
  final Widget child;
  final int serverId, partId, itemId;
  final String course;

  const PartItemLayout({Key key, this.child, this.serverId, this.partId, this.itemId, this.course})
      : super(key: key);

  @override
  _PartItemLayoutState createState() => _PartItemLayoutState();
}

class _PartItemLayoutState extends State<PartItemLayout> {
  CoursePartBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = CoursePartModule.to.get<CoursePartBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CoursePart>(
        stream: bloc.coursePart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData)
            return Scaffold(body: RouterOutlet());
          var data = snapshot.data;
          return DefaultTabController(
              length: data.items.length,
              initialIndex: widget.itemId,
              child: Scaffold(
                  drawer: CourseDrawer(
                    course: data.course,
                    onChange: (int index) {
                      Modular.to.pushNamed(Uri(pathSegments: [
                        "",
                        "courses",
                        "start",
                        "item"
                      ], queryParameters: <String, String>{
                        "serverId": widget.serverId.toString(),
                        "course": widget.course,
                        "partId": index.toString()
                      }).toString());
                      setState(() => bloc.reset());
                      bloc?.fetch(serverId: widget.serverId, course: widget.course, partId: index);
                    },
                  ),
                  appBar: MyAppBar(
                    title: snapshot.data.name,
                    height: 125,
                    bottom: TabBar(
                        isScrollable: true,
                        onTap: (index) => Modular.to.pushReplacementNamed(Uri(pathSegments: [
                              "",
                              "courses",
                              "start",
                              "item"
                            ], queryParameters: {
                              "serverId": widget.serverId.toString(),
                              "course": widget.course,
                              "partId": widget.partId.toString(),
                              "itemId": index.toString()
                            }).toString()),
                        tabs: List.generate(data.items.length, (index) {
                          var item = data.items[index];
                          if (item is TextPartItem)
                            return Tab(icon: Icon(Icons.subject_outlined), text: item.name);
                          else if (item is QuizPartItem)
                            return Tab(icon: Icon(Icons.question_answer_outlined), text: item.name);
                          else if (item is VideoPartItem)
                            return Tab(icon: Icon(Icons.play_arrow_outlined), text: item.name);
                          return null;
                        })),
                  ),
                  body: widget.child));
        });
  }
}
