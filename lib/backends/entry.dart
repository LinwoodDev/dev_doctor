import 'package:dev_doctor/editor/bloc/course.dart';
import 'package:dev_doctor/editor/bloc/server.dart';
import 'package:dev_doctor/models/collection.dart';
import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

import 'home.dart';

class BackendPage extends StatefulWidget {
  final String user;
  final String entry;
  final int collectionId;
  final CoursesServer model;
  final ServerEditorBloc editorBloc;

  const BackendPage(
      {Key key, this.user, this.entry, this.collectionId, this.model, this.editorBloc})
      : super(key: key);

  @override
  _BackendPageState createState() => _BackendPageState();
}

class _BackendPageState extends State<BackendPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  Future<CoursesServer> _buildFuture() async {
    if (widget.model != null) return widget.model;
    var collection = await BackendCollection.fetch(index: widget.collectionId);
    var currentUser = await collection.fetchUser(widget.user);
    var currentEntry = currentUser.buildEntry(widget.entry);
    var server = await currentEntry.fetchServer();
    return server;
  }

  @override
  Widget build(BuildContext context) {
    return widget.model != null
        ? _buildView(widget.model)
        : widget.editorBloc != null
            ? _buildView(widget.editorBloc.server)
            : FutureBuilder<CoursesServer>(
                future: _buildFuture(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                      var server = snapshot.data;
                      return _buildView(server);
                  }
                });
  }

  Widget _buildView(CoursesServer server) => Builder(
      builder: (context) => Scaffold(
            body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: widget.editorBloc != null ? null : 400.0,
                      floating: false,
                      pinned: true,
                      actions: [if (widget.editorBloc == null) AddBackendButton(server: server)],
                      bottom: widget.editorBloc != null
                          ? TabBar(
                              controller: _tabController,
                              tabs: [Tab(text: "General"), Tab(text: "Courses")],
                              indicatorSize: TabBarIndicatorSize.label,
                              isScrollable: true,
                            )
                          : null,
                      title: Text(server.name),
                      flexibleSpace: widget.editorBloc != null
                          ? null
                          : FlexibleSpaceBar(
                              background: Container(
                                  margin: EdgeInsets.fromLTRB(10, 20, 10, 84),
                                  child: Hero(
                                      tag: widget.editorBloc != null
                                          ? "editor-backend-${widget.editorBloc.server.name}"
                                          : "backend-icon-${server.entry.collection.index}-${server.entry.user.name}-${server.entry.name}",
                                      child: widget.editorBloc != null
                                          ? Container()
                                          : UniversalImage(
                                              url: server.url + "/icon",
                                              height: 500,
                                              type: server.icon,
                                            ))),
                            ),
                    )
                  ];
                },
                body: widget.editorBloc != null
                    ? TabBarView(
                        controller: _tabController,
                        children: [_buildGeneral(context, server), _buildCourses(context)])
                    : _buildGeneral(context, server)),
            floatingActionButton: _buildFab(),
          ));

  Widget _buildCourses(BuildContext context) => Scrollbar(child: ListView(children: []));

  Widget _buildFab() {
    return _tabController.index == 0
        ? null
        : FloatingActionButton(
            onPressed: _showCreateCourseDialog,
            child: Icon(Icons.add_outlined),
          );
  }

  Widget _buildGeneral(BuildContext context, CoursesServer server) => Scrollbar(
          child: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                      padding: const EdgeInsets.all(64.0),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        if (widget.editorBloc == null)
                          Padding(
                              padding: const EdgeInsets.all(16),
                              child: TextButton.icon(
                                  onPressed: () async => await Modular.to.pushNamed(
                                      "/backends/user?collectionId=${widget.collectionId}&user=${widget.user}",
                                      arguments: server.entry.user),
                                  icon: Icon(Icons.account_circle_outlined),
                                  label: Text(widget.user))),
                        Row(children: [
                          Expanded(
                              child: (server.body != null)
                                  ? MarkdownBody(
                                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                                      onTapLink: (_, url, __) => launch(url),
                                      extensionSet: md.ExtensionSet(
                                        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                                        [
                                          md.EmojiSyntax(),
                                          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                                        ],
                                      ),
                                      data: server.body,
                                      selectable: true,
                                    )
                                  : Container()),
                          IconButton(icon: Icon(Icons.edit_outlined), onPressed: () {})
                        ])
                      ]))))
        ],
      ));
  void _showCreateCourseDialog() {
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
                            labelText: 'course.add.name'.tr(), hintText: 'course.add.hint'.tr()),
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
                        _createCourse(name);
                      })
                ]));
  }

  void _createCourse(String name) {
    widget.editorBloc.courses.add(CourseEditorBloc(Course(name: name)));
    widget.editorBloc.save();
  }
}
