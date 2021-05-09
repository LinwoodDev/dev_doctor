import 'package:dev_doctor/courses/drawer.dart';
import 'package:dev_doctor/editor/part.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/item.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:easy_localization/easy_localization.dart';

import '../course.dart';
import 'bloc.dart';
import 'module.dart';

class PartItemLayout extends StatefulWidget {
  final Widget? child;
  final ServerEditorBloc? editorBloc;
  final CoursePart part;
  final int? itemId;

  const PartItemLayout({Key? key, this.child, this.itemId, this.editorBloc, required this.part})
      : super(key: key);

  @override
  _PartItemLayoutState createState() => _PartItemLayoutState();
}

class _PartItemLayoutState extends State<PartItemLayout> {
  late CoursePartBloc bloc;

  @override
  void initState() {
    bloc = CoursePartModule.to.get<CoursePartBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: widget.part.items.length,
        initialIndex: widget.itemId ?? 0,
        child: Scaffold(
            drawer: CoursePartDrawer(
              editorBloc: widget.editorBloc,
              course: widget.part.course,
              onChange: (int index) {
                Modular.to.pushReplacementNamed(Uri(
                    pathSegments: widget.editorBloc != null
                        ? ["", "editor", "course", "item"]
                        : ["", "courses", "start", "item"],
                    queryParameters: <String, String>{
                      ...Modular.args!.queryParams,
                      "partId": index.toString(),
                      "itemId": 0.toString()
                    }).toString());
              },
            ),
            appBar: MyAppBar(
              title: widget.part.name,
              height: 125,
              actions: [
                if (widget.editorBloc != null) ...[
                  if (widget.part.items.isNotEmpty)
                    IconButton(
                        tooltip: "course.delete.item.tooltip".tr(),
                        icon: Icon(Icons.remove_circle_outline_outlined),
                        onPressed: () => _showDeleteDialog(widget.part, widget.itemId ?? 0)),
                  IconButton(
                      tooltip: "course.add.item.tooltip".tr(),
                      icon: Icon(Icons.add_circle_outline_outlined),
                      onPressed: () => _showCreateDialog(widget.part)),
                  EditorCoursePartPopupMenu(
                      bloc: widget.editorBloc!, partBloc: EditorPartModule.to.get<CoursePartBloc>())
                ] else
                  IconButton(
                    icon: Icon(Icons.share_outlined),
                    tooltip: "share".tr(),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text: Uri(
                                  scheme: Uri.base.scheme,
                                  port: Uri.base.port,
                                  host: Uri.base.host,
                                  fragment: Uri(pathSegments: [
                                    "",
                                    "courses",
                                    "start",
                                    "item"
                                  ], queryParameters: {
                                    "server": widget.part.server!.url,
                                    "course": bloc.course,
                                    "part": bloc.part
                                  }).toString())
                              .toString()));
                    },
                  )
              ],
              bottom: TabBar(
                  isScrollable: true,
                  onTap: (index) => Modular.to.pushReplacementNamed(Uri(
                          pathSegments: widget.editorBloc != null
                              ? ["", "editor", "course", "item"]
                              : ["", "courses", "start", "item"],
                          queryParameters: {
                            ...Modular.args!.queryParams,
                            "itemId": index.toString()
                          }).toString()),
                  tabs: List.generate(widget.part.items.length, (index) {
                    var item = widget.part.items[index];
                    var text = Text(item.name,
                        overflow: TextOverflow.fade,
                        style: widget.editorBloc == null && !widget.part.itemVisited(index)
                            ? TextStyle(fontWeight: FontWeight.bold)
                            : null);
                    return Tab(icon: Icon(item.icon), child: text);
                  })),
            ),
            body: widget.child));
  }

  void _showCreateDialog(CoursePart part) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    PartItemTypes type = PartItemTypes.text;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            scrollable: true,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("cancel".tr().toUpperCase())),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _createItem(part,
                        name: nameController.text,
                        description: descriptionController.text,
                        type: type);
                  },
                  child: Text("create".tr().toUpperCase()))
            ],
            title: Text("course.add.item.title".tr()),
            content: Container(
                child: Form(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: "course.add.item.name.label".tr(),
                      hintText: "course.add.item.name.hint".tr())),
              TextFormField(
                  controller: descriptionController,
                  maxLines: null,
                  minLines: 3,
                  decoration: InputDecoration(
                      labelText: "course.add.item.description.label".tr(),
                      hintText: "course.add.item.description.hint".tr())),
              DropdownButtonFormField<PartItemTypes>(
                  decoration: InputDecoration(labelText: "course.add.item.type".tr()),
                  value: type,
                  onChanged: (value) => setState(() => type = value ?? PartItemTypes.text),
                  items: PartItemTypes.values
                      .map((e) => DropdownMenuItem<PartItemTypes>(
                          child: Text("course.type.${e.name}".tr()), value: e))
                      .toList())
            ])))));
  }

  Future<void> _createItem(CoursePart part,
      {required String name, required String description, required PartItemTypes type}) async {
    var params = Modular.args!.queryParams;
    var courseBloc = widget.editorBloc!.getCourse(
        params['course'] ?? widget.editorBloc!.server.courses[int.parse(params['courseId']!)]);
    var value = type.create(name: name, description: description);
    var current = part.copyWith(items: List<PartItem>.from(part.items)..add(value));
    courseBloc.updateCoursePart(current);
    await widget.editorBloc!.save();
    setState(() {
      bloc.partSubject.add(current);
    });
  }

  void _showDeleteDialog(CoursePart part, int index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            scrollable: true,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("no".tr().toUpperCase())),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteItem(part, index);
                  },
                  child: Text("yes".tr().toUpperCase()))
            ],
            title: Text("course.delete.item.title".tr()),
            content: Text("course.delete.item.content"
                .tr(namedArgs: {'index': index.toString(), 'name': part.items[index].name}))));
  }

  Future<void> _deleteItem(CoursePart part, int index) async {
    var params = Modular.args!.queryParams;
    var courseBloc = widget.editorBloc!.getCourse(
        params['course'] ?? widget.editorBloc!.server.courses[int.parse(params['courseId']!)]);
    var items = List<PartItem>.from(part.items);
    items.removeAt(index);
    var current = part.copyWith(items: items);
    courseBloc.updateCoursePart(current);
    await widget.editorBloc!.save();
    setState(() {
      bloc.partSubject.add(current);
    });
  }
}
