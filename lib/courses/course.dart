import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'package:markdown/markdown.dart' as md;
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursePage extends StatefulWidget {
  final Course model;
  final String course;
  final int serverId;
  final ServerEditorBloc editorBloc;

  const CoursePage({Key key, this.course, this.serverId, this.model, this.editorBloc})
      : super(key: key);
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> with TickerProviderStateMixin {
  ServerEditorBloc _editorBloc;
  TabController _tabController;
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _slugController;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _editorBloc = widget.editorBloc;
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    if (_editorBloc != null) {
      var courseBloc = _editorBloc.getCourse(widget.course);
      _nameController = TextEditingController(text: courseBloc.course.name);
      _descriptionController = TextEditingController(text: courseBloc.course.description);
      _slugController = TextEditingController(text: courseBloc.course.slug);
    }
  }

  void _handleTabIndex() {
    setState(() {});
  }

  Future<Course> _buildFuture() async {
    if (widget.model != null) return widget.model;
    if (widget.editorBloc != null) return widget.editorBloc.getCourse(widget.course).course;
    CoursesServer server = await CoursesServer.fetch(index: widget.serverId);
    return server.fetchCourse(widget.course);
  }

  @override
  Widget build(BuildContext context) {
    return widget.model != null
        ? _buildView(widget.model)
        : widget.editorBloc != null
            ? _buildView(widget.editorBloc?.getCourse(widget.course)?.course)
            : FutureBuilder<Course>(
                future: _buildFuture(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                      var course = snapshot.data;
                      print(course);
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
    if (_editorBloc.getCourse(widget.course).parts.map((e) => e.course.slug).contains(name))
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text("course.add.exist.title").tr(),
                  content: Text("course.add.exist.content").tr(),
                  actions: [
                    TextButton.icon(
                        icon: Icon(Icons.close_outlined),
                        onPressed: () => Navigator.of(context).pop(),
                        label: Text("close".tr().toUpperCase()))
                  ]));
    else {
      _editorBloc.createCourse(name);
      _editorBloc.save();
      setState(() {});
    }
  }

  Widget _buildView(Course course) => Builder(builder: (context) {
        var supportUrl = course.supportUrl ?? course.server?.supportUrl;
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
                                '/courses/start/item?serverId=${widget.serverId}&course=${widget.course}&partId=0'),
                          )
                        } else
                          IconButton(
                              icon: Icon(Icons.save_outlined),
                              tooltip: "save".tr(),
                              onPressed: () {}),
                        VerticalDivider(),
                        WindowButtons()
                      ],
                      bottom: _editorBloc != null
                          ? TabBar(
                              controller: _tabController,
                              tabs: [Tab(text: "General"), Tab(text: "Parts")],
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
                            ))
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

  Widget _buildGeneral(BuildContext context, Course course) {
    var _slugs = _editorBloc?.courses?.map((e) => e.course.slug);
    var data = """"Changes are automatically rendered as you type.

  * Implements [GitHub Flavored Markdown](https://github.github.com/gfm/)
  * Renders actual, "native" React DOM elements
  * Allows you to escape or skip HTML (try toggling the checkboxes above)
  * If you escape or skip the HTML, no `dangerouslySetInnerHTML` is used! Yay!

  ## Table of Contents

  ## HTML block below

  <blockquote>
    This blockquote will change based on the HTML settings above.
  </blockquote>

  ## How about some fe?

  ```
  var React = require('react');
  var Markdown = require('react-markdown');

  React.render(
    <Markdown source="# Your markdown here" />,
    document.getElementById('content')
  );
  ```

  Pretty neat, eh?

  ## Tables?

  | Feature   | Support |
  | :-------: | ------- |
  | tables    | âœ” |
  | alignment | âœ” |
  | wewt      | âœ” |

  ## More info?

  Read usage information and more on [GitHub](https://github.com/remarkjs/react-markdown)

  ---------------

  A component by [Espen Hovlandsdal](https://espen.codes/)""";
    return Scrollbar(
        child: ListView(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(4),
          child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(children: [
                    if (_editorBloc != null)
                      Form(
                          key: _formKey,
                          child: Container(
                              constraints: BoxConstraints(maxWidth: 1000),
                              child: Column(children: [
                                TextFormField(
                                    decoration: InputDecoration(
                                        labelText: "course.name.label".tr(),
                                        hintText: "course.name.hint".tr()),
                                    validator: (value) {
                                      if (value.isEmpty) return "course.name.empty".tr();
                                      return null;
                                    },
                                    controller: _nameController),
                                TextFormField(
                                    decoration: InputDecoration(
                                        labelText: "course.slug.label".tr(),
                                        hintText: "course.slug.hint".tr()),
                                    validator: (value) {
                                      if (value.isEmpty) return "course.slug.empty".tr();
                                      if (_slugs.contains(value) && value != course.slug)
                                        return "course.slug.exist".tr();
                                      return null;
                                    },
                                    controller: _slugController),
                                TextFormField(
                                    decoration: InputDecoration(
                                        labelText: "course.description.label".tr(),
                                        hintText: "course.description.hint".tr()),
                                    controller: _descriptionController),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ElevatedButton.icon(
                                      onPressed: () async {
                                        var courseBloc = _editorBloc.changeCourseSlug(
                                            widget.course, _slugController.text);
                                        courseBloc.course =
                                            courseBloc.course.copyWith(name: _nameController.text);
                                        courseBloc.save();
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.save_outlined),
                                      label: Text("save".tr().toUpperCase())),
                                ),
                                Divider()
                              ]))),
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
                          Text(course.author == null
                              ? _editorBloc != null
                                  ? 'course.author.notset'.tr()
                                  : ''
                              : course.author),
                          if (_editorBloc != null)
                            IconButton(icon: Icon(Icons.edit_outlined), onPressed: () {})
                        ])),
                    if (course.lang != null || _editorBloc != null)
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Padding(
                                padding: EdgeInsets.all(4), child: Icon(Icons.language_outlined)),
                            Text(course.lang != null
                                ? LocaleNames.of(context).nameOf(course.lang)
                                : 'course.lang.notset'),
                            if (_editorBloc != null)
                              IconButton(icon: Icon(Icons.edit_outlined), onPressed: () {})
                          ])),
                    Row(children: [
                      Expanded(
                          child: (course.body != null)
                              ? MarkdownBody(
                                  onTapLink: (_, url, __) => launch(url),
                                  data: data,
                                  selectable: true,
                                )
                              : Container()),
                      if (_editorBloc != null)
                        IconButton(icon: Icon(Icons.edit_outlined), onPressed: () {})
                    ])
                  ]))))
    ]));
  }

  Widget _buildParts(BuildContext context) {
    var parts = _editorBloc?.getCourse(widget.course)?.parts;
    return Scrollbar(
        child: ListView.builder(
      itemCount: parts.length,
      itemBuilder: (context, index) {
        var part = parts[index];
        return Dismissible(
            background: Container(color: Colors.red),
            onDismissed: (direction) async {
              _editorBloc.deleteCourse(part.slug);
              _editorBloc.save();
            },
            key: Key(part.slug),
            child: ListTile(
                title: Text(part.name),
                subtitle: Text(part.description ?? ""),
                onTap: () => Modular.to.pushNamed(
                    '/editor/part?serverId=${_editorBloc.key}&course=${widget.course}&part=$index')));
      },
    ));
  }
}
