import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

typedef EditorCallback = void Function(String markdown);

class MarkdownEditor extends StatefulWidget {
  final String markdown;
  final EditorCallback onSubmit;

  const MarkdownEditor({Key key, this.markdown, this.onSubmit}) : super(key: key);
  @override
  _MarkdownEditorState createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  String markdown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(actions: [
          IconButton(
              icon: Icon(Icons.play_arrow_outlined),
              onPressed: () => Modular.to
                  .push(MaterialPageRoute(builder: (context) => _MarkdownEditorPreview())))
        ]),
        body: _buildTextEditor());
  }

  Widget _buildTextEditor() => SingleChildScrollView(
      child: Container(
          child: TextField(),
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width)));
}

class _MarkdownEditorPreview extends StatelessWidget {
  final String markdown;

  const _MarkdownEditorPreview({Key key, this.markdown}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: "editor.markdown.preview.title".tr()),
        body: MarkdownBody(
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
          onTapLink: (_, url, __) => launch(url),
          extensionSet: md.ExtensionSet(
            md.ExtensionSet.gitHubFlavored.blockSyntaxes,
            [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
          ),
          data: markdown,
          selectable: true,
        ));
  }
}
