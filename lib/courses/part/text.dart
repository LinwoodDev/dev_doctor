import 'package:dev_doctor/models/items/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

class TextPartItemPage extends StatelessWidget {
  final TextPartItem item;

  const TextPartItemPage({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: MarkdownBody(
      onTapLink: (_, url, __) => launch(url),
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
      ),
      data: item.text,
      selectable: true,
    ));
  }
}
