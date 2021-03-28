import 'package:dev_doctor/models/author.dart';
import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/author.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/foundation.dart';
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

  void _showLanguageDialog() {
    var courseBloc = _editorBloc.getCourse(widget.course);
    var language = '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                contentPadding: const EdgeInsets.all(16.0),
                content: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        onChanged: (value) => language = value,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                            labelText: 'course.lang.label'.tr(), hintText: 'course.lang.hint'.tr()),
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
                        courseBloc.course = courseBloc.course.copyWith(lang: language);
                        _editorBloc.save();
                        Navigator.pop(context);
                        setState(() {});
                      })
                ]));
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
                            labelText: 'course.part.add.name'.tr(),
                            hintText: 'course.part.add.hint'.tr()),
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
    _editorBloc.getCourse(widget.course).createCoursePart(name);
    _editorBloc.save();
    setState(() {});
  }

  void _showRenamePartDialog() {
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
                            labelText: 'course.part.add.name'.tr(),
                            hintText: 'course.part.add.hint'.tr()),
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

  Future<void> _renamePart(String name) async {
    _editorBloc.getCourse(widget.course).createCoursePart(name);
    _editorBloc.save();
    setState(() {});
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
                              onPressed: () => Modular.to.pushNamed(Uri(pathSegments: [
                                    "",
                                    "courses",
                                    "start",
                                    "item"
                                  ], queryParameters: {
                                    "serverId": widget.serverId.toString(),
                                    "course": widget.course,
                                    "partId": 0.toString()
                                  }).toString()))
                        } else
                          IconButton(
                              icon: Icon(Icons.save_outlined),
                              tooltip: "save".tr(),
                              onPressed: () {}),
                        if (!kIsWeb && isWindow()) ...[VerticalDivider(), WindowButtons()]
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
                                        courseBloc.course = courseBloc.course.copyWith(
                                            name: _nameController.text,
                                            slug: _slugController.text,
                                            description: _descriptionController.text);
                                        _editorBloc.save();
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.save_outlined),
                                      label: Text("save".tr().toUpperCase())),
                                ),
                                Divider()
                              ]))),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      AuthorDisplay(author: course.author, editing: _editorBloc != null),
                      if (_editorBloc != null) ...[
                        IconButton(
                            icon: Icon(Icons.edit_outlined),
                            onPressed: () => Modular.to.pushNamed(Uri(pathSegments: [
                                  '',
                                  'editor',
                                  'course',
                                  'author'
                                ], queryParameters: {
                                  "serverId": _editorBloc.key.toString(),
                                  "course": widget.course
                                }).toString())),
                        if (course.author?.name != null)
                          IconButton(
                              icon: Icon(Icons.delete_outline_outlined),
                              onPressed: () async {
                                var courseBloc = _editorBloc.getCourse(widget.course);
                                course = courseBloc.course.copyWith(author: Author());
                                courseBloc.course = course;
                                await _editorBloc.save();
                                setState(() {});
                              })
                      ]
                    ]),
                    if (course.lang != null || _editorBloc != null)
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Padding(
                                padding: EdgeInsets.all(4), child: Icon(Icons.language_outlined)),
                            Text(course.lang != null
                                ? LocaleNames.of(context).nameOf(course.lang) ?? course.lang
                                : 'course.lang.notset'.tr()),
                            if (_editorBloc != null)
                              IconButton(
                                  icon: Icon(Icons.edit_outlined),
                                  onPressed: () => _showLanguageDialog())
                          ])),
                    Row(children: [
                      Expanded(
                          child: (course.body != null)
                              ? MarkdownBody(
                                  onTapLink: (_, url, __) => launch(url),
                                  data: course.body ?? '',
                                  selectable: true,
                                )
                              : Container()),
                      if (_editorBloc != null)
                        IconButton(
                            icon: Icon(Icons.edit_outlined),
                            onPressed: () => Modular.to.pushNamed(Uri(pathSegments: [
                                  "",
                                  "editor",
                                  "course",
                                  "edit"
                                ], queryParameters: {
                                  "serverId": _editorBloc.key.toString(),
                                  "course": widget.course
                                }).toString()))
                    ])
                  ]))))
    ]));
  }

  Widget _buildParts(BuildContext context) {
    var course = _editorBloc?.getCourse(widget.course);
    var parts = course?.parts;
    return Scrollbar(
        child: ListView.builder(
      itemCount: parts.length,
      itemBuilder: (context, index) {
        var part = parts[index];
        return Dismissible(
            background: Container(color: Colors.red),
            onDismissed: (direction) async {
              _editorBloc.getCourse(widget.course).deleteCoursePart(part.slug);
              _editorBloc.save();
            },
            key: Key(part.slug),
            child: ListTile(
                title: Text(part.name),
                subtitle: Text(part.description ?? ""),
                trailing: PopupMenuButton<PartOptions>(
                  onSelected: (option) {},
                  itemBuilder: (context) {
                    return PartOptions.values
                        .map((e) => PopupMenuItem<PartOptions>(
                            child: Row(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(e.icon),
                              ),
                              Text(e.title)
                            ]),
                            value: e))
                        .toList();
                  },
                ),
                onTap: () => Modular.to.pushNamed(Uri(pathSegments: [
                      "",
                      "editor",
                      "course",
                      "item"
                    ], queryParameters: {
                      "serverId": _editorBloc.key.toString(),
                      "course": widget.course,
                      "part": part.slug
                    }).toString())));
      },
    ));
  }
}

enum PartOptions { rename, description, slug }

extension PartOptionsExtension on PartOptions {
  String get title {
    switch (this) {
      case PartOptions.rename:
        return 'course.part.rename'.tr();
      case PartOptions.description:
        return 'course.part.description'.tr();
      case PartOptions.slug:
        return 'course.part.slug'.tr();
    }
    return null;
  }

  IconData get icon {
    switch (this) {
      case PartOptions.rename:
        return Icons.edit_outlined;
      case PartOptions.description:
        return Icons.text_snippet_outlined;
      case PartOptions.slug:
        return Icons.link_outlined;
    }
    return null;
  }

  void onSelected(ServerEditorBloc bloc, String course, int index) {
    //var courseBloc = bloc.getCourse(course);
    //var partItem = courseBloc.parts[index];
    switch (this) {
      case PartOptions.rename:
        // TODO: Handle this case.
        break;
      case PartOptions.description:
        Modular.to.navigate(Uri(
            pathSegments: ["", "editor", "part", "edit"],
            queryParameters: {"serverId": bloc.key, "course": course, "partId": index}).toString());
        break;
      case PartOptions.slug:
        // TODO: Handle this case.
        break;
    }
  }
}
