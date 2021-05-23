import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

typedef EditorCallback = void Function(String markdown);

class MarkdownEditor extends StatefulWidget {
  final String markdown;
  final EditorCallback onSubmit;

  const MarkdownEditor({Key? key, this.markdown = "", required this.onSubmit}) : super(key: key);
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
        return _buildAppBar(
            isMobile,
            Row(children: [
              Expanded(child: textEditor, flex: 2),
              Expanded(
                  child:
                      _MarkdownEditorPreview(markdown: _markdownController!.text, isMobile: false))
            ]));
      return _buildAppBar(isMobile, textEditor);
    });
  }

  Widget _buildAppBar(bool isMobile, Widget child) => Scaffold(
      appBar: MyAppBar(title: "editor.markdown.title".tr(), actions: [
        if (isMobile)
          IconButton(
              tooltip: "editor.markdown.preview.button".tr(),
              icon: Icon(PhosphorIcons.playLight),
              onPressed: () => Modular.to.push(MaterialPageRoute(
                  builder: (context) =>
                      _MarkdownEditorPreview(markdown: _markdownController!.text)))),
        IconButton(
            tooltip: "save".tr(),
            icon: Icon(PhosphorIcons.floppyDiskLight),
            onPressed: () => widget.onSubmit(_markdownController!.text))
      ]),
      body: child);

  Widget _buildTextEditor(bool isMobile) => Scrollbar(
          child: SingleChildScrollView(
              child: Container(
                  child: TextField(
        controller: _markdownController,
        onChanged: (value) {
          setState(() {});
        },
        maxLines: null,
      ))));
}

class _MarkdownEditorPreview extends StatelessWidget {
  final String markdown;
  final bool isMobile;
  final ScrollController _scrollController = ScrollController();

  _MarkdownEditorPreview({Key? key, this.markdown = "", this.isMobile = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? Scaffold(
            appBar: MyAppBar(
                title: "editor.markdown.preview.title".tr(), automaticallyImplyLeading: isMobile),
            body: _buildContent(context))
        : Container(child: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) => Scrollbar(
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
              data: markdown,
              selectable: true)));
}
