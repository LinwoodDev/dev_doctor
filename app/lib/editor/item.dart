import 'package:dev_doctor/courses/part/bloc.dart';
import 'package:dev_doctor/models/editor/course.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/item.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PartItemEditorPage extends StatefulWidget {
  final ServerEditorBloc? editorBloc;
  final String? course;
  final int? courseId;
  final String? part;
  final int? partId;
  final int? itemId;

  const PartItemEditorPage(
      {Key? key, this.editorBloc, this.itemId, this.part, this.course, this.courseId, this.partId})
      : super(key: key);

  @override
  _PartItemEditorPageState createState() => _PartItemEditorPageState();
}

class _PartItemEditorPageState extends State<PartItemEditorPage> {
  late CourseEditorBloc bloc;
  late CoursePartBloc partBloc;
  late CoursePart part;
  TextEditingController? _nameController;
  TextEditingController? _descriptionController;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    partBloc = Modular.get<CoursePartBloc>();
    bloc = widget.editorBloc!
        .getCourse(widget.course ?? widget.editorBloc!.courses[widget.courseId!] as String);
    part = bloc.getCoursePart(widget.part ?? bloc.course.parts[widget.partId!]);
    var item = part.items[widget.itemId!];
    _nameController = TextEditingController(text: item.name);
    _descriptionController = TextEditingController(text: item.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: 'editor.item.title'.tr()),
        body: Form(
            key: _formKey,
            child: Scrollbar(
                child: Center(
                    child: Container(
                        constraints: BoxConstraints(maxWidth: 1000),
                        child: ListView(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value!.isEmpty) return 'editor.item.name.empty'.tr();
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'editor.item.name.hint'.tr(),
                                  labelText: 'editor.item.name.label'.tr()),
                            ),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                  hintText: 'editor.item.description.hint'.tr(),
                                  labelText: 'editor.item.description.label'.tr()),
                            )
                          ],
                        ))))),
        floatingActionButton: FloatingActionButton(
            child: Icon(PhosphorIcons.floppyDiskLight),
            tooltip: "save".tr(),
            onPressed: () async {
              var coursePart = part.copyWith(
                  items: List<PartItem>.from(part.items)
                    ..[widget.itemId!] = part.items[widget.itemId!].copyWith(
                        name: _nameController!.text, description: _descriptionController!.text));
              bloc.updateCoursePart(coursePart);
              await widget.editorBloc!.save();
              partBloc.partSubject.add(coursePart);
              setState(() {});
            }));
  }
}
