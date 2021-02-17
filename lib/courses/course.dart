import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursePage extends StatefulWidget {
  final Course model;
  final int courseId;
  final int serverId;

  const CoursePage({Key key, this.courseId, this.serverId, this.model}) : super(key: key);
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  Future<Course> _buildFuture() async {
    if (widget.model != null) return widget.model;
    CoursesServer server = await CoursesServer.fetch(index: widget.serverId);
    return server.fetchCourse(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.model != null
            ? _buildView(widget.model)
            : FutureBuilder<Course>(
                future: _buildFuture(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                      var course = snapshot.data;
                      return _buildView(course);
                  }
                }));
  }

  Widget _buildView(Course course) => NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        var supportUrl = course.supportUrl ?? course.server.supportUrl;
        return <Widget>[
          SliverAppBar(
            expandedHeight: 400.0,
            floating: false,
            pinned: true,
            actions: [
              if (supportUrl != null)
                IconButton(
                    icon: Icon(Icons.help_outline_outlined),
                    tooltip: "course.support".tr(),
                    onPressed: () => launch(supportUrl)),
              IconButton(
                icon: Icon(Icons.play_circle_outline_outlined),
                tooltip: "course.start".tr(),
                onPressed: () => Modular.to.navigate(
                    '/courses/start/item?serverId=${widget.serverId}&courseId=${widget.courseId}&partId=0'),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withAlpha(200),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(course.name)),
              background: Container(
                  margin: EdgeInsets.fromLTRB(10, 20, 10, 84),
                  child: Hero(
                      tag: "course-icon-${widget.serverId}-${widget.courseId}",
                      child: UniversalImage(
                        url: course.url + "/icon",
                        height: 500,
                        type: course.icon,
                      ))),
            ),
          )
        ];
      },
      body: Scrollbar(
          child: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(4),
              child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(children: [
                        GestureDetector(
                            onTap: () {
                              if (course.authorUrl != null) launch(course.authorUrl);
                            },
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              if (course.authorAvatar != null)
                                Padding(
                                    padding: EdgeInsets.all(8),
                                    child: CircleAvatar(
                                      child: ClipOval(
                                        child: Image.network(course.authorAvatar),
                                      ),
                                    )),
                              Text(course.author ?? "")
                            ])),
                        if (course.lang != null)
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(Icons.language_outlined)),
                                Text(LocaleNames.of(context).nameOf(course.lang))
                              ]))
                      ])))),
          Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                      padding: const EdgeInsets.all(64.0),
                      child: MarkdownBody(
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                        onTapLink: (_, url, __) => launch(url),
                        extensionSet: md.ExtensionSet(
                          md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                          [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
                        ),
                        data: course.body,
                        selectable: true,
                      )))),
        ],
      )));
}
