import 'package:dev_doctor/models/items/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

class TextPartItemPage extends StatelessWidget {
  final TextPartItem item;
  final bool editing;

  const TextPartItemPage({Key key, this.item, this.editing}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: [
      Expanded(
          child: MarkdownBody(
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        onTapLink: (_, url, __) => launch(url),
        extensionSet: md.ExtensionSet(
          md.ExtensionSet.gitHubFlavored.blockSyntaxes,
          [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
        ),
        data: item.text,
        selectable: true,
      )),
      if (editing)
        IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () => Modular.to.pushNamed(Uri(
                pathSegments: ['', 'editor', 'course', 'content'],
                queryParameters: {...Modular.args.queryParams}).toString()))
    ]));
  }
}
