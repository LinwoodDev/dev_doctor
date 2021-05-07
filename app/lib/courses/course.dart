import 'dart:convert';

import 'package:dev_doctor/courses/bloc.dart';
import 'package:dev_doctor/courses/module.dart';
import 'package:dev_doctor/courses/part/bloc.dart';
import 'package:dev_doctor/editor/code.dart';
import 'package:dev_doctor/editor/module.dart';
import 'package:dev_doctor/models/author.dart';
import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/author.dart';
import 'package:dev_doctor/widgets/error.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'package:markdown/markdown.dart' as md;
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'statistics.dart';

class CoursePage extends StatefulWidget {
  final Course? model;
  final ServerEditorBloc? editorBloc;

  const CoursePage({Key? key, this.model, this.editorBloc}) : super(key: key);
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> with TickerProviderStateMixin {
  ServerEditorBloc? _editorBloc;
  late CourseBloc bloc;
  late TabController _tabController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _supportController;
  late TextEditingController _slugController;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _editorBloc = widget.editorBloc;
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    if (_editorBloc != null)
      bloc = EditorModule.to.get<CourseBloc>();
    else
      bloc = CourseModule.to.get<CourseBloc>();
    bloc.fetchFromParams(editorBloc: _editorBloc);
    if (_editorBloc != null) {
      var courseBloc = _editorBloc!.getCourse(bloc.course!);
      _nameController = TextEditingController(text: courseBloc.course.name);
      _descriptionController = TextEditingController(text: courseBloc.course.description);
      _slugController = TextEditingController(text: courseBloc.course.slug);
      _supportController = TextEditingController(text: courseBloc.course.supportUrl ?? '');
    }
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.model != null
        ? _buildView(widget.model!)
        : widget.editorBloc != null
            ? _buildView(widget.editorBloc!.getCourse(bloc.course!).course)
            : StreamBuilder<Course>(
                stream: bloc.courseSubject,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError || bloc.hasError) return ErrorDisplay();
                      var course = snapshot.data;
                      return _buildView(course!);
                  }
                });
  }

  Widget? _buildFab() {
    return _tabController.index == 0 || _editorBloc == null
        ? null
        : FloatingActionButton(
            tooltip: "create".tr(),
            onPressed: _showCreatePartDialog,
            child: Icon(Icons.add_outlined),
          );
  }

  void _showLanguageDialog() {
    var courseBloc = _editorBloc!.getCourse(bloc.course!);
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
                        keyboardType: TextInputType.text,
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
                        _editorBloc?.save();
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
                        keyboardType: TextInputType.text,
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
    _editorBloc!.getCourse(bloc.course!).createCoursePart(name);
    _editorBloc?.save();
    setState(() {});
  }

  Widget _buildView(Course course) => Builder(builder: (context) {
        var supportUrl = course.supportUrl ?? course.server?.supportUrl;
        return Scaffold(
          body: Scrollbar(
              child: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                          expandedHeight: _editorBloc != null ? null : 400.0,
                          floating: false,
                          pinned: true,
                          actions: [
                            if (_editorBloc == null) ...{
                              IconButton(
                                  icon: Icon(Icons.share_outlined),
                                  tooltip: "share",
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: Uri(
                                                scheme: Uri.base.scheme,
                                                port: Uri.base.port,
                                                host: Uri.base.host,
                                                fragment: Uri(pathSegments: [
                                                  "",
                                                  "courses",
                                                  "details"
                                                ], queryParameters: {
                                                  "server": course.server!.url,
                                                  "course": bloc.course
                                                }).toString())
                                            .toString()));
                                  }),
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
                                        ...Modular.args!.queryParams,
                                        "partId": 0.toString()
                                      }).toString()))
                            } else
                              IconButton(
                                  icon: Icon(Icons.code_outlined),
                                  tooltip: "code".tr(),
                                  onPressed: () async {
                                    var packageInfo = await PackageInfo.fromPlatform();
                                    var buildNumber = int.tryParse(packageInfo.buildNumber);
                                    var encoder = JsonEncoder.withIndent("  ");
                                    var data = await Modular.to.push(MaterialPageRoute(
                                        builder: (context) => EditorCodeDialogPage(
                                            initialValue:
                                                encoder.convert(course.toJson(buildNumber)))));
                                    if (data != null) {
                                      var courseBloc = _editorBloc!.getCourse(bloc.course!);
                                      courseBloc.course = Course.fromJson(data);
                                      _editorBloc?.save();
                                      setState(() {});
                                    }
                                  }),
                            if (!kIsWeb && isWindow()) ...[VerticalDivider(), WindowButtons()]
                          ],
                          bottom: TabBar(
                            controller: _tabController,
                            tabs: [
                              Tab(text: "general".tr()),
                              Tab(
                                  text: _editorBloc != null
                                      ? "course.parts".tr()
                                      : "course.statistics.title".tr())
                            ],
                            indicatorSize: TabBarIndicatorSize.label,
                            isScrollable: true,
                          ),
                          title: Text(course.name),
                          flexibleSpace: _editorBloc != null
                              ? null
                              : FlexibleSpaceBar(
                                  background: Container(
                                      margin: EdgeInsets.fromLTRB(10, 20, 10, 84),
                                      child: _editorBloc != null
                                          ? Container()
                                          : Hero(
                                              tag:
                                                  "course-icon-${course.server?.index}-${course.slug}",
                                              child: UniversalImage(
                                                url: course.url + "/icon",
                                                height: 500,
                                                type: course.icon,
                                              ))),
                                ))
                    ];
                  },
                  body: TabBarView(controller: _tabController, children: [
                    _buildGeneral(context, course),
                    _editorBloc != null ? _buildParts(context) : _buildStatistics(course)
                  ]))),
          floatingActionButton: _buildFab(),
        );
      });

  Widget _buildGeneral(BuildContext context, Course course) {
    var _slugs = _editorBloc?.courses.map((e) => e.course.slug);
    return ListView(children: <Widget>[
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
                                      if (value!.isEmpty) return "course.name.empty".tr();
                                      return null;
                                    },
                                    controller: _nameController),
                                TextFormField(
                                    decoration: InputDecoration(
                                        labelText: "course.slug.label".tr(),
                                        hintText: "course.slug.hint".tr()),
                                    validator: (value) {
                                      if (value!.isEmpty) return "course.slug.empty".tr();
                                      if (_slugs!.contains(value) && value != course.slug)
                                        return "course.slug.exist".tr();
                                      return null;
                                    },
                                    controller: _slugController),
                                TextFormField(
                                    keyboardType: TextInputType.url,
                                    decoration: InputDecoration(
                                        labelText: "course.support.label".tr(),
                                        hintText: "course.support.hint".tr()),
                                    controller: _supportController),
                                TextFormField(
                                    decoration: InputDecoration(
                                        labelText: "course.description.label".tr(),
                                        hintText: "course.description.hint".tr()),
                                    controller: _descriptionController),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ElevatedButton.icon(
                                      onPressed: () async {
                                        var courseBloc = _editorBloc!
                                            .changeCourseSlug(bloc.course!, _slugController.text);
                                        courseBloc.course = courseBloc.course.copyWith(
                                            name: _nameController.text,
                                            slug: _slugController.text,
                                            supportUrl: _supportController.text.isEmpty
                                                ? null
                                                : _supportController.text,
                                            description: _descriptionController.text);
                                        _editorBloc?.save();
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.save_outlined),
                                      label: Text("save".tr().toUpperCase())),
                                ),
                                Divider()
                              ]))),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      if (course.author != null)
                        AuthorDisplay(author: course.author!, editing: _editorBloc != null),
                      if (_editorBloc != null) ...[
                        IconButton(
                            tooltip: "edit".tr(),
                            icon: Icon(Icons.edit_outlined),
                            onPressed: () => Modular.to.pushNamed(Uri(pathSegments: [
                                  '',
                                  'editor',
                                  'course',
                                  'author'
                                ], queryParameters: {
                                  "serverId": _editorBloc!.key.toString(),
                                  "course": bloc.course!
                                }).toString())),
                        if (course.author?.name != null)
                          IconButton(
                              tooltip: "delete".tr(),
                              icon: Icon(Icons.delete_outline_outlined),
                              onPressed: () async {
                                var courseBloc = _editorBloc!.getCourse(bloc.course!);
                                course = courseBloc.course.copyWith(author: Author());
                                courseBloc.course = course;
                                await _editorBloc?.save();
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
                                ? LocaleNames.of(context)!.nameOf(course.lang!) ?? course.lang!
                                : 'course.lang.notset'.tr()),
                            if (_editorBloc != null)
                              IconButton(
                                  tooltip: "edit".tr(),
                                  icon: Icon(Icons.edit_outlined),
                                  onPressed: () => _showLanguageDialog())
                          ])),
                    Row(children: [
                      Expanded(
                          child: (!course.body.isEmpty)
                              ? MarkdownBody(
                                  onTapLink: (_, url, __) => launch(url!),
                                  data: course.body,
                                  selectable: true,
                                )
                              : Container()),
                      if (_editorBloc != null)
                        IconButton(
                            tooltip: "edit".tr(),
                            icon: Icon(Icons.edit_outlined),
                            onPressed: () => Modular.to.pushNamed(Uri(pathSegments: [
                                  "",
                                  "editor",
                                  "course",
                                  "edit"
                                ], queryParameters: {
                                  "serverId": _editorBloc!.key.toString(),
                                  "course": bloc.course!
                                }).toString()))
                    ])
                  ]))))
    ]);
  }

  Widget _buildParts(BuildContext context) {
    var course = _editorBloc!.getCourse(bloc.course!);
    List<CoursePart> parts = course.parts;
    return Scrollbar(
        child: ListView.builder(
      itemCount: parts.length,
      itemBuilder: (context, index) {
        var part = parts[index];
        return Dismissible(
            background: Container(color: Colors.red),
            onDismissed: (direction) async {
              _editorBloc!.getCourse(bloc.course!).deleteCoursePart(part.slug);
              _editorBloc?.save();
            },
            key: Key(part.slug),
            child: ListTile(
                title: Text(part.name),
                subtitle: Text(part.description),
                onTap: () => Modular.to.pushNamed(Uri(pathSegments: [
                      "",
                      "editor",
                      "course",
                      "item"
                    ], queryParameters: {
                      "serverId": _editorBloc!.key.toString(),
                      "course": bloc.course!,
                      "part": part.slug
                    }).toString())));
      },
    ));
  }

  Widget _buildStatistics(Course course) => CourseStatisticsView(course: course);
}

class EditorCoursePartPopupMenu extends StatelessWidget {
  final CoursePartBloc partBloc;
  final ServerEditorBloc bloc;

  const EditorCoursePartPopupMenu({Key? key, required this.bloc, required this.partBloc})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PartOptions>(
      onSelected: (option) {
        option.onSelected(context, bloc, partBloc);
      },
      itemBuilder: (context) {
        return PartOptions.values.map<PopupMenuEntry<PartOptions>>((e) {
          var description =
              e.getDescription(bloc.getCourse(partBloc.course!).getCoursePart(partBloc.part!));
          return PopupMenuItem<PartOptions>(
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(e.icon, color: Theme.of(context).iconTheme.color),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(e.title!),
                  if (description != null)
                    Text(description, style: Theme.of(context).textTheme.caption)
                ])
              ]),
              value: e);
        }).toList()
          ..insert(3, PopupMenuDivider());
      },
    );
  }
}

enum PartOptions { rename, description, slug, code }

extension PartOptionsExtension on PartOptions {
  String? get title {
    switch (this) {
      case PartOptions.rename:
        return 'course.part.rename'.tr();
      case PartOptions.description:
        return 'course.part.description'.tr();
      case PartOptions.slug:
        return 'course.part.slug'.tr();
      case PartOptions.code:
        return 'code'.tr();
    }
  }

  IconData? get icon {
    switch (this) {
      case PartOptions.rename:
        return Icons.edit_outlined;
      case PartOptions.description:
        return Icons.text_snippet_outlined;
      case PartOptions.slug:
        return Icons.link_outlined;
      case PartOptions.code:
        return Icons.code_outlined;
    }
  }

  String? getDescription(CoursePart part) {
    switch (this) {
      case PartOptions.slug:
        return part.slug;
      case PartOptions.rename:
        return part.name;
      case PartOptions.description:
        return part.description;
      default:
        return null;
    }
  }

  Future<void> onSelected(
      BuildContext context, ServerEditorBloc bloc, CoursePartBloc partBloc) async {
    var courseBloc = bloc.getCourse(partBloc.course!);
    var coursePart = courseBloc.getCoursePart(partBloc.part!);
    switch (this) {
      case PartOptions.rename:
        var nameController = TextEditingController(text: coursePart.name);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    contentPadding: const EdgeInsets.all(16.0),
                    content: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: 'course.part.rename.name'.tr(),
                                hintText: 'course.part.rename.hint'.tr()),
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
                          child: Text('change'.tr().toUpperCase()),
                          onPressed: () async {
                            Navigator.pop(context);
                            var courseBloc = bloc.getCourse(partBloc.course!);
                            coursePart = coursePart.copyWith(name: nameController.text);
                            courseBloc.updateCoursePart(coursePart);
                            await bloc.save();
                            partBloc.partSubject.add(coursePart);
                          })
                    ]));
        break;
      case PartOptions.description:
        var descriptionController = TextEditingController(text: coursePart.description);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    contentPadding: const EdgeInsets.all(16.0),
                    content: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: descriptionController,
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                labelText: 'course.part.description.name'.tr(),
                                hintText: 'course.part.description.hint'.tr()),
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
                          child: Text('change'.tr().toUpperCase()),
                          onPressed: () async {
                            Navigator.pop(context);
                            var courseBloc = bloc.getCourse(partBloc.course!);
                            coursePart =
                                coursePart.copyWith(description: descriptionController.text);
                            courseBloc.updateCoursePart(coursePart);
                            await bloc.save();
                            partBloc.partSubject.add(coursePart);
                          })
                    ]));
        break;
      case PartOptions.slug:
        var slugController = TextEditingController(text: coursePart.slug);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    contentPadding: const EdgeInsets.all(16.0),
                    content: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: slugController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: 'course.part.slug.name'.tr(),
                                hintText: 'course.part.slug.hint'.tr()),
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
                          child: Text('change'.tr().toUpperCase()),
                          onPressed: () async {
                            Navigator.pop(context);
                            var courseBloc = bloc.getCourse(partBloc.course!);
                            courseBloc.changeCoursePartSlug(coursePart.slug, slugController.text);
                            await bloc.save();
                            Modular.to.pushReplacementNamed(Uri(pathSegments: [
                              '',
                              ...Modular.args!.uri!.pathSegments
                            ], queryParameters: {
                              ...Modular.args!.queryParams,
                              'part': slugController.text
                            }).toString());
                          })
                    ]));
        break;
      case PartOptions.code:
        var encoder = JsonEncoder.withIndent("  ");
        var packageInfo = await PackageInfo.fromPlatform();
        var buildNumber = int.tryParse(packageInfo.buildNumber);
        var data = await Modular.to.push(MaterialPageRoute(
            builder: (context) => EditorCodeDialogPage(
                initialValue: encoder.convert(coursePart.toJson(buildNumber)))));
        if (data != null) {
          var part = CoursePart.fromJson(data..['course'] = courseBloc.course);
          partBloc.partSubject.add(part);
          courseBloc.updateCoursePart(part);
          bloc.save();
        }
        break;
    }
  }
}
