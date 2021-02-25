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
  @override
  _PartItemLayoutState createState() => _PartItemLayoutState();
}

class _PartItemLayoutState extends State<PartItemLayout> {
  CoursePartBloc bloc;
  int serverId, courseId, partId, itemId;

  @override
  void initState() {
    super.initState();
    _buildBloc();
  }

  void _buildBloc() {
    var params = Modular.args.queryParams;
    bloc = CoursePartModule.to.get<CoursePartBloc>();
    serverId = int.parse(params['serverId']);
    courseId = int.parse(params['courseId']);
    partId = int.parse(params['partId']);
    itemId = int.parse(params['itemId'] ?? '0');
    bloc?.fetch(serverId: serverId, courseId: courseId, partId: partId);
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
              initialIndex: itemId,
              child: Scaffold(
                  drawer: CourseDrawer(
                    course: data.course,
                    onChange: (int index) {
                      Modular.to.navigate(
                          "/courses/start/item?serverId=$serverId&courseId=$courseId&partId=$index");
                      setState(() => bloc.reset());
                      bloc?.fetch(serverId: serverId, courseId: courseId, partId: index);
                    },
                  ),
                  appBar: MyAppBar(
                    title: snapshot.data.name,
                    bottom: TabBar(
                        isScrollable: true,
                        onTap: (index) => Modular.to.pushReplacementNamed(
                            "/courses/start/item?serverId=$serverId&courseId=$courseId&partId=$partId&itemId=$index"),
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
                  body: RouterOutlet()));
        });
  }
}
