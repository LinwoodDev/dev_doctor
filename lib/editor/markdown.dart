import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

typedef EditorCallback = void Function(String markdown);

class MarkdownEditor extends StatefulWidget {
  final String? markdown;
  final EditorCallback? onSubmit;

  const MarkdownEditor({Key? key, this.markdown, this.onSubmit}) : super(key: key);
  @override
  _MarkdownEditorState createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  TextEditingController? _markdownController;
  @override
  void initState() {
    _markdownController = TextEditingController(text: widget.markdown);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var isMobile = MediaQuery.of(context).size.width <= 1000;
      var textEditor = _buildTextEditor(isMobile);
      if (!isMobile)
        return Row(children: [
          Expanded(child: textEditor, flex: 2),
          Expanded(
              child: _MarkdownEditorPreview(markdown: _markdownController!.text, isMobile: false))
        ]);
      return textEditor;
    });
  }

  Widget _buildTextEditor(bool isMobile) => Scaffold(
      appBar: MyAppBar(title: "editor.markdown.title".tr(), actions: [
        if (isMobile)
          IconButton(
              icon: Icon(Icons.play_arrow_outlined),
              onPressed: () => Modular.to.push(MaterialPageRoute(
                  builder: (context) =>
                      _MarkdownEditorPreview(markdown: _markdownController!.text)))),
        IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: () => widget.onSubmit!(_markdownController!.text))
      ]),
      body: Scrollbar(
          child: SingleChildScrollView(
              child: Container(
                  child: TextField(
        controller: _markdownController,
        onChanged: (value) {
          setState(() {});
        },
        maxLines: null,
      )))));
}

class _MarkdownEditorPreview extends StatelessWidget {
  final String? markdown;
  final bool isMobile;
  final ScrollController _scrollController = ScrollController();

  _MarkdownEditorPreview({Key? key, this.markdown, this.isMobile = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
            title: "editor.markdown.preview.title".tr(), automaticallyImplyLeading: isMobile),
        body: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
                controller: _scrollController,
                child: MarkdownBody(
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                    onTapLink: (_, url, __) => launch(url!),
                    extensionSet: md.ExtensionSet(
                      md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                      [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
                    ),
                    data: markdown!,
                    selectable: true))));
  }
}
