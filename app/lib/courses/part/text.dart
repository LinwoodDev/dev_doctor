import 'package:dev_doctor/courses/part/bloc.dart';
import 'package:dev_doctor/editor/markdown.dart';
import 'package:dev_doctor/editor/part.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/item.dart';
import 'package:dev_doctor/models/items/text.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class TextPartItemPage extends StatefulWidget {
  final TextPartItem item;
  final CoursePart part;
  final ServerEditorBloc? editorBloc;
  final int itemId;

  const TextPartItemPage(
      {Key? key, required this.item, required this.part, this.editorBloc, required this.itemId})
      : super(key: key);

  @override
  _TextPartItemPageState createState() => _TextPartItemPageState();
}

class _TextPartItemPageState extends State<TextPartItemPage> {
  @override
  void initState() {
    super.initState();

    widget.part.setItemPoints(widget.itemId, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: [
      Expanded(
          child: MarkdownBody(
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        onTapLink: (_, url, __) => launch(url!),
        extensionSet: md.ExtensionSet(
          md.ExtensionSet.gitHubFlavored.blockSyntaxes,
          [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
        ),
        data: widget.item.text ?? '',
        selectable: true,
      )),
      if (widget.editorBloc != null)
        IconButton(
            tooltip: "edit".tr(),
            icon: Icon(Icons.edit_outlined),
            onPressed: () {
              Modular.to.push(MaterialPageRoute(
                  builder: (context) => MarkdownEditor(
                      markdown: widget.item.text,
                      onSubmit: (value) {
                        var bloc = EditorPartModule.to.get<CoursePartBloc>();
                        var courseBloc = widget.editorBloc!.getCourse(bloc.course!);
                        var coursePart = courseBloc.getCoursePart(bloc.part!);
                        var part = coursePart.copyWith(
                            items: List<PartItem>.from(coursePart.items)
                              ..[widget.itemId] = widget.item.copyWith(text: value));
                        courseBloc.updateCoursePart(part);
                        bloc.partSubject.add(part);
                        widget.editorBloc!.save();
                      })));
            })
    ]));
  }
}
