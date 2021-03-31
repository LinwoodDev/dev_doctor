import 'package:dev_doctor/courses/part/bloc.dart';
import 'package:dev_doctor/editor/markdown.dart';
import 'package:dev_doctor/editor/part.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/item.dart';
import 'package:dev_doctor/models/items/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

class TextPartItemPage extends StatelessWidget {
  final TextPartItem? item;
  final ServerEditorBloc? editorBloc;
  final int? itemId;

  const TextPartItemPage({Key? key, this.item, this.editorBloc, this.itemId}) : super(key: key);
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
        data: item!.text!,
        selectable: true,
      )),
      if (editorBloc != null)
        IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () {
              Modular.to.push(MaterialPageRoute(
                  builder: (context) => MarkdownEditor(
                      markdown: item!.text,
                      onSubmit: (value) {
                        var bloc = EditorPartModule.to.get<CoursePartBloc>();
                        var courseBloc = editorBloc!.getCourse(bloc.course!);
                        var coursePart = courseBloc.getCoursePart(bloc.part);
                        var part = coursePart.copyWith(
                            items: List<PartItem>.from(coursePart.items)
                              ..[itemId!] = item!.copyWith(text: value));
                        courseBloc.updateCoursePart(part);
                        bloc.coursePart.add(part);
                        editorBloc!.save();
                      })));
            })
    ]));
  }
}
