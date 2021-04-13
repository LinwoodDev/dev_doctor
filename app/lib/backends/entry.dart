import 'dart:convert';

import 'package:dev_doctor/editor/code.dart';
import 'package:dev_doctor/models/collection.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/error.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

import 'home.dart';

class BackendPage extends StatefulWidget {
  final String? user;
  final String? entry;
  final int? collectionId;
  final CoursesServer? model;
  final ServerEditorBloc? editorBloc;

  const BackendPage(
      {Key? key, this.user, this.entry, this.collectionId, this.model, this.editorBloc})
      : super(key: key);

  @override
  _BackendPageState createState() => _BackendPageState();
}

class _BackendPageState extends State<BackendPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _nameController;
  late TextEditingController _noteController;
  GlobalKey<FormState> _formKey = GlobalKey();
  Box<ServerEditorBloc> _box = Hive.box<ServerEditorBloc>('editor');
  ServerEditorBloc? _editorBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    _editorBloc = widget.editorBloc;
    if (_editorBloc != null) {
      _nameController = TextEditingController(text: _editorBloc!.server.name);
      _noteController = TextEditingController(text: _editorBloc!.note);
    }
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

  Future<CoursesServer?> _buildFuture() async {
    if (widget.model != null) return widget.model!;
    var collection = await BackendCollection.fetch(index: widget.collectionId);
    var currentUser = await collection?.fetchUser(widget.user);
    if (widget.entry != null) {
      var currentEntry = currentUser?.buildEntry(widget.entry!);
      var server = await currentEntry?.fetchServer();
      return server;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.model != null
        ? _buildView(widget.model!)
        : _editorBloc != null
            ? _buildView(_editorBloc!.server)
            : FutureBuilder<CoursesServer?>(
                future: _buildFuture(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                      var server = snapshot.data;
                      if (server == null) return ErrorDisplay();
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
                        expandedHeight: _editorBloc != null ? null : 400.0,
                        floating: false,
                        pinned: true,
                        actions: [
                          if (_editorBloc == null)
                            AddBackendButton(server: server)
                          else
                            IconButton(
                                icon: Icon(Icons.code_outlined),
                                tooltip: "code".tr(),
                                onPressed: () async {
                                  var encoder = JsonEncoder.withIndent("  ");
                                  var data = await Modular.to.push(MaterialPageRoute(
                                      builder: (context) => EditorCodeDialogPage(
                                          initialValue: encoder.convert(server.toJson()))));
                                  if (data != null) {
                                    var server = CoursesServer.fromJson(data);
                                    _editorBloc!.server = server;
                                    await _editorBloc?.save();
                                    setState(() {
                                      _nameController.text = server.name;
                                    });
                                  }
                                }),
                          if (!kIsWeb && isWindow()) ...[VerticalDivider(), WindowButtons()]
                        ],
                        bottom: _editorBloc != null
                            ? TabBar(
                                controller: _tabController,
                                tabs: [Tab(text: "General"), Tab(text: "Courses")],
                                indicatorSize: TabBarIndicatorSize.label,
                                isScrollable: true,
                              )
                            : null,
                        title: Text(server.name),
                        flexibleSpace: _editorBloc != null
                            ? null
                            : FlexibleSpaceBar(
                                background: Container(
                                    margin: EdgeInsets.fromLTRB(10, 20, 10, 84),
                                    child: Hero(
                                        tag: _editorBloc != null
                                            ? "editor-backend-${_editorBloc!.server.name}"
                                            : "backend-icon-${server.entry!.collection.index}-${server.entry!.user.name}-${server.entry!.name}",
                                        child: _editorBloc != null
                                            ? Container()
                                            : UniversalImage(
                                                url: server.url! + "/icon",
                                                height: 500,
                                                type: server.icon,
                                              )))))
                  ];
                },
                body: _editorBloc != null
                    ? TabBarView(
                        controller: _tabController,
                        children: [_buildGeneral(context, server), _buildCourses(context)])
                    : _buildGeneral(context, server)),
            floatingActionButton: _buildFab(),
          ));

  Widget _buildCourses(BuildContext context) => Scrollbar(
          child: ListView.builder(
        itemCount: _editorBloc!.courses.length,
        itemBuilder: (context, index) {
          var courseBloc = _editorBloc!.courses[index];
          return Dismissible(
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                _editorBloc!.deleteCourse(courseBloc.course.slug);
                await _editorBloc?.save();
                setState(() {});
              },
              key: Key(courseBloc.course.slug),
              child: ListTile(
                  title: Text(courseBloc.course.name),
                  subtitle: Text(courseBloc.course.description ?? ""),
                  onTap: () => Modular.to.pushNamed(Uri(pathSegments: [
                        "",
                        "editor",
                        "course"
                      ], queryParameters: {
                        "serverId": _editorBloc!.key.toString(),
                        "course": courseBloc.course.slug
                      }).toString())));
        },
      ));

  Widget? _buildFab() {
    return _tabController.index == 0
        ? null
        : FloatingActionButton(
            onPressed: _showCreateCourseDialog,
            child: Icon(Icons.add_outlined),
          );
  }

  Widget _buildGeneral(BuildContext context, CoursesServer server) {
    var _names = _box.values.map((e) => e.server.name);
    return Scrollbar(
        child: ListView(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(16),
            child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                    padding: const EdgeInsets.all(64.0),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      if (_editorBloc == null) ...[
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextButton.icon(
                                onPressed: () async => await Modular.to.pushNamed(
                                    "/backends/user?collectionId=${widget.collectionId}&user=${widget.user}",
                                    arguments: {"user": server.entry!.user, "server": server}),
                                icon: Icon(Icons.account_circle_outlined),
                                label: Text(widget.user!))),
                      ] else
                        Form(
                            key: _formKey,
                            child: Container(
                                constraints: BoxConstraints(maxWidth: 1000),
                                child: Column(children: [
                                  TextFormField(
                                      decoration: InputDecoration(
                                          labelText: "editor.create.name.label".tr(),
                                          hintText: "editor.create.name.hint".tr()),
                                      validator: (value) {
                                        if (value!.isEmpty) return "editor.create.name.empty".tr();
                                        if (_names.contains(value) &&
                                            value != _editorBloc!.server.name)
                                          return "editor.create.name.exist".tr();
                                        return null;
                                      },
                                      controller: _nameController),
                                  TextFormField(
                                      decoration: InputDecoration(
                                          labelText: "editor.create.note.label".tr(),
                                          hintText: "editor.create.note.hint".tr()),
                                      controller: _noteController),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ElevatedButton.icon(
                                        onPressed: () async {
                                          if (!_formKey.currentState!.validate()) return;
                                          _editorBloc!.server =
                                              server.copyWith(name: _nameController.text);
                                          _editorBloc!.note = _noteController.text;
                                          await _editorBloc?.save();
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.save_outlined),
                                        label: Text("save".tr().toUpperCase())),
                                  ),
                                  Divider()
                                ]))),
                      Row(children: [
                        Expanded(
                            child: (server.body != null)
                                ? MarkdownBody(
                                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                                    onTapLink: (_, url, __) => launch(url!),
                                    extensionSet: md.ExtensionSet(
                                      md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                                      [
                                        md.EmojiSyntax(),
                                        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                                      ],
                                    ),
                                    data: server.body!,
                                    selectable: true,
                                  )
                                : Container()),
                        IconButton(
                            icon: Icon(Icons.edit_outlined),
                            onPressed: () => Modular.to
                                .pushNamed('/editor/edit?serverId=${_editorBloc!.key.toString()}'))
                      ])
                    ]))))
      ],
    ));
  }

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
                        keyboardType: TextInputType.text,
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

  Future<void> _createCourse(String name) async {
    if (_editorBloc!.courses.map((e) => e.course.slug).contains(name))
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
      _editorBloc!.createCourse(name);
      _editorBloc?.save();
      setState(() {});
    }
  }
}
