import 'package:dev_doctor/editor/bloc/course.dart';
import 'package:dev_doctor/editor/bloc/server.dart';
import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/part.dart';
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
  final ServerEditorBloc editorBloc;

  const CoursePage({Key key, this.courseId, this.serverId, this.model, this.editorBloc})
      : super(key: key);
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> with TickerProviderStateMixin {
  ServerEditorBloc _editorBloc;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _editorBloc = widget.editorBloc;
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  void _handleTabIndex() {
    setState(() {});
  }

  Future<Course> _buildFuture() async {
    if (widget.model != null) return widget.model;
    if (widget.editorBloc != null) return widget.editorBloc.courses[widget.courseId].course;
    CoursesServer server = await CoursesServer.fetch(index: widget.serverId);
    return server.fetchCourse(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return widget.model != null
        ? _buildView(widget.model)
        : widget.editorBloc != null
            ? _buildView(widget.editorBloc.courses[widget.courseId].course)
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
                });
  }

  Widget _buildFab() {
    return _tabController.index == 0
        ? null
        : FloatingActionButton(
            onPressed: _showCreatePartDialog,
            child: Icon(Icons.add_outlined),
          );
  }

  void _showCreatePartDialog() {
    var name = '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                contentPadding: const EdgeInsets.all(16.0),
                content: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        onChanged: (value) => name = value,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                            labelText: 'course.add.part.name'.tr(),
                            hintText: 'course.add.part.hint'.tr()),
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      child: Text('cancel'.tr().toUpperCase()),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  TextButton(
                      child: Text('create'.tr().toUpperCase()),
                      onPressed: () async {
                        Navigator.pop(context);
                        _createPart(name);
                      })
                ]));
  }

  Future<void> _createPart(String name) async {
    if (_editorBloc.courses[widget.courseId].parts.map((e) => e.course.slug).contains(name))
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text("course.add.exist.title").tr(),
                  content: Text("course.add.exist.content").tr(),
                  actions: [
                    TextButton.icon(
                        icon: Icon(Icons.close_outlined),
                        onPressed: () => Navigator.of(context).pop(),
                        label: Text("close").tr())
                  ]));
    else {
      var parts = List<CoursePart>.from(_editorBloc.courses[widget.courseId].parts)
        ..add(CoursePart(name: name));
      var courses = List<CourseEditorBloc>.from(_editorBloc.courses)
        ..[widget.courseId].copyWith(parts: parts);
      _editorBloc = await _editorBloc.copyWith(courses: courses).save();
      setState(() {});
    }
  }

  Widget _buildView(Course course) => Builder(builder: (context) {
        var supportUrl = course.supportUrl ?? course.server.supportUrl;
        return Scaffold(
          body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: _editorBloc != null ? null : 400.0,
                    floating: false,
                    pinned: true,
                    actions: [
                      if (_editorBloc == null) ...{
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
                      } else
                        IconButton(
                            icon: Icon(Icons.save_outlined), tooltip: "save".tr(), onPressed: () {})
                    ],
                    bottom: _editorBloc != null
                        ? TabBar(
                            controller: _tabController,
                            tabs: [Tab(text: "General"), Tab(text: "Courses")],
                            indicatorSize: TabBarIndicatorSize.label,
                            isScrollable: true,
                          )
                        : null,
                    title: Text(course.name),
                    flexibleSpace: _editorBloc != null
                        ? null
                        : FlexibleSpaceBar(
                            background: Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 84),
                                child: Hero(
                                    tag: _editorBloc != null
                                        ? "course-icon-${_editorBloc.server.name}"
                                        : "course-icon-${course.server.index}-${course.index}",
                                    child: _editorBloc != null
                                        ? Container()
                                        : UniversalImage(
                                            url: course.url + "/icon",
                                            height: 500,
                                            type: course.icon,
                                          ))),
                          ),
                  )
                ];
              },
              body: _editorBloc != null
                  ? TabBarView(
                      controller: _tabController,
                      children: [_buildGeneral(context, course), _buildParts(context)])
                  : _buildGeneral(context, course)),
          floatingActionButton: _buildFab(),
        );
      });

  Widget _buildGeneral(BuildContext context, Course course) => Scrollbar(
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
      ));
  Widget _buildParts(BuildContext context) {
    var parts = _editorBloc.courses[widget.courseId].parts;
    return Scrollbar(
        child: ListView.builder(
      itemCount: parts.length,
      itemBuilder: (context, index) {
        var part = parts[index];
        return Dismissible(
            background: Container(color: Colors.red),
            onDismissed: (direction) async {
              _editorBloc = await _editorBloc
                  .copyWith(courses: List.from(_editorBloc.courses)..remove(part))
                  .save();
            },
            key: Key(part.slug),
            child: ListTile(title: Text(part.name), subtitle: Text(part.description ?? "")));
      },
    ));
  }
}
