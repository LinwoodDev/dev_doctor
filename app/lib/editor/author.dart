import 'package:dev_doctor/models/author.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/author.dart';
import 'package:dev_doctor/widgets/image_type.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

typedef EditorCallback = void Function(Author? author);

class AuthorEditingPage extends StatefulWidget {
  final EditorCallback onSubmit;
  final Author? author;

  const AuthorEditingPage({Key? key, required this.onSubmit, this.author}) : super(key: key);
  @override
  _AuthorEditingPageState createState() => _AuthorEditingPageState();
}

class _AuthorEditingPageState extends State<AuthorEditingPage> {
  TextEditingController? _nameController;
  TextEditingController? _urlController;
  TextEditingController? _avatarController;
  GlobalKey<FormState> _formKey = GlobalKey();
  late Author _author;
  @override
  void initState() {
    _author = widget.author ?? Author();
    _nameController = TextEditingController(text: _author.name);
    _urlController = TextEditingController(text: _author.url);
    _avatarController = TextEditingController(text: _author.avatar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: "course.author.title".tr()),
        body: Form(
            key: _formKey,
            child: Scrollbar(
                child: Center(
                    child: Container(
                        constraints: BoxConstraints(maxWidth: 1000),
                        child: ListView(children: [
                          TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) return "course.author.name.empty".tr();
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: "course.author.name.label".tr(),
                                  hintText: "course.author.name.hint".tr()),
                              onChanged: (value) => setState(
                                  () => _author = _author.copyWith(name: _nameController!.text)),
                              controller: _nameController),
                          TextFormField(
                              decoration: InputDecoration(
                                  labelText: "course.author.url.label".tr(),
                                  hintText: "course.author.url.hint".tr()),
                              keyboardType: TextInputType.url,
                              onChanged: (value) => setState(
                                  () => _author = _author.copyWith(url: _urlController!.text)),
                              controller: _urlController),
                          TextFormField(
                              decoration: InputDecoration(
                                  suffix: ImageTypeDropdown(
                                      defaultValue: _author.avatarType,
                                      onChanged: (value) =>
                                          setState(() => _author.copyWith(avatarType: value))),
                                  labelText: "course.author.avatar.label".tr(),
                                  hintText: "course.author.avatar.hint".tr()),
                              onChanged: (value) => setState(() =>
                                  _author = _author.copyWith(avatar: _avatarController!.text)),
                              keyboardType: TextInputType.url,
                              controller: _avatarController),
                          SizedBox(height: 10),
                          AuthorDisplay(author: _author),
                          SizedBox(height: 10)
                        ]))))),
        floatingActionButton: FloatingActionButton(
            child: Icon(PhosphorIcons.checkLight),
            tooltip: "editor.create.submit".tr(),
            onPressed: () => widget.onSubmit(_author)));
  }
}
