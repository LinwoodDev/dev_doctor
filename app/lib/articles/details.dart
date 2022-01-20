import 'dart:convert';

import 'package:dev_doctor/articles/bloc.dart';
import 'package:dev_doctor/editor/code.dart';
import 'package:dev_doctor/models/article.dart';
import 'package:dev_doctor/models/author.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/author.dart';
import 'package:dev_doctor/widgets/error.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlePage extends StatefulWidget {
  final Article? model;
  final ServerEditorBloc? editorBloc;

  const ArticlePage({Key? key, this.model, this.editorBloc}) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  ServerEditorBloc? _editorBloc;
  late ArticleBloc bloc;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _slugController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _editorBloc = widget.editorBloc;
    bloc = Modular.get<ArticleBloc>();
    bloc.fetchFromParams(editorBloc: _editorBloc);
    if (_editorBloc != null) {
      initEditor();
    }
  }

  void initEditor() {
    var article = _editorBloc!.getArticle(bloc.article!);
    _titleController.text = article.title;
    _slugController.text = article.slug;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Article>(
        stream: bloc.articleSubject,
        builder: (context, snapshot) {
          if (snapshot.hasError || bloc.hasError) return const ErrorDisplay();
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var article = snapshot.data!;
          return _buildView(article);
        });
  }

  Widget _buildView(Article article) {
    var _slugs = _editorBloc?.getArticlesSlug();
    return Scaffold(
        appBar: AppBar(title: Text(article.title), actions: [
          if (_editorBloc == null) ...[
            IconButton(
                icon: const Icon(PhosphorIcons.shareNetworkLight),
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
                                "details"
                              ], queryParameters: {
                                "server": article.server!.url,
                                "course": bloc.article
                              }).toString())
                          .toString()));
                })
          ] else
            IconButton(
                icon: const Icon(PhosphorIcons.codeLight),
                tooltip: "code".tr(),
                onPressed: () async {
                  //var packageInfo = await PackageInfo.fromPlatform();
                  //var buildNumber = int.tryParse(packageInfo.buildNumber);
                  var encoder = const JsonEncoder.withIndent("  ");
                  var data = await Modular.to.push(MaterialPageRoute(
                      builder: (context) => EditorCodeDialogPage(
                          initialValue: encoder.convert(article.toJson()))));
                  if (data != null) {
                    var article = Article.fromJson(data);
                    _editorBloc?.updateArticle(article);
                    bloc.articleSubject.add(article);
                    _editorBloc?.save();
                    initEditor();
                  }
                }),
          if (!kIsWeb && isWindow()) ...[
            const VerticalDivider(),
            const WindowButtons()
          ]
        ]),
        body: ListView(children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(4),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(children: [
                        if (_editorBloc != null)
                          Form(
                              key: _formKey,
                              child: Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 1000),
                                  child: Column(children: [
                                    TextFormField(
                                        decoration: InputDecoration(
                                            labelText:
                                                "article.title.label".tr(),
                                            hintText:
                                                "article.title.hint".tr()),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "article.title.empty".tr();
                                          }
                                          return null;
                                        },
                                        controller: _titleController),
                                    TextFormField(
                                        decoration: InputDecoration(
                                            labelText:
                                                "article.slug.label".tr(),
                                            hintText: "article.slug.hint".tr()),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "article.slug.empty".tr();
                                          }
                                          if (_slugs!.contains(value) &&
                                              value != article.slug) {
                                            return "article.slug.exist".tr();
                                          }
                                          return null;
                                        },
                                        controller: _slugController),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ElevatedButton.icon(
                                          onPressed: () async {
                                            var article = _editorBloc!
                                                .changeArticleSlug(
                                                    bloc.article!,
                                                    _slugController.text);
                                            article = article.copyWith(
                                                title: _titleController.text);
                                            _editorBloc?.updateArticle(article);
                                            _editorBloc?.save();
                                            bloc.articleSubject.add(article);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                              PhosphorIcons.floppyDiskLight),
                                          label:
                                              Text("save".tr().toUpperCase())),
                                    ),
                                    const Divider()
                                  ]))),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (article.author.name.isNotEmpty)
                                AuthorDisplay(
                                    author: article.author,
                                    editing: _editorBloc != null),
                              if (_editorBloc != null) ...[
                                IconButton(
                                    tooltip: "edit".tr(),
                                    icon: const Icon(PhosphorIcons.pencilLight),
                                    onPressed: () => Modular.to.pushNamed(Uri(
                                            pathSegments: [
                                              '',
                                              'editor',
                                              'article',
                                              'author'
                                            ],
                                            queryParameters: {
                                              "serverId":
                                                  _editorBloc!.key.toString(),
                                              "article": bloc.article!
                                            }).toString())),
                                if (article.author.name.isNotEmpty)
                                  IconButton(
                                      tooltip: "delete".tr(),
                                      icon:
                                          const Icon(PhosphorIcons.trashLight),
                                      onPressed: () async {
                                        var articleBloc = _editorBloc!
                                            .getArticle(bloc.article!);
                                        article = articleBloc.copyWith(
                                            author: const Author());
                                        _editorBloc?.updateArticle(article);
                                        bloc.articleSubject.add(article);
                                        await _editorBloc?.save();
                                        setState(() {});
                                      })
                              ]
                            ]),
                        Row(children: [
                          Expanded(
                              child: (article.body.isNotEmpty)
                                  ? MarkdownBody(
                                      onTapLink: (_, url, __) => launch(url!),
                                      extensionSet: md.ExtensionSet(
                                        md.ExtensionSet.gitHubFlavored
                                            .blockSyntaxes,
                                        [
                                          md.EmojiSyntax(),
                                          ...md.ExtensionSet.gitHubFlavored
                                              .inlineSyntaxes
                                        ],
                                      ),
                                      data: article.body,
                                      selectable: true,
                                    )
                                  : Container()),
                          if (_editorBloc != null)
                            IconButton(
                                tooltip: "edit".tr(),
                                icon: const Icon(PhosphorIcons.pencilLight),
                                onPressed: () => Modular.to.pushNamed(
                                        Uri(pathSegments: [
                                      "",
                                      "editor",
                                      "article",
                                      "edit"
                                    ], queryParameters: {
                                      "serverId": _editorBloc!.key.toString(),
                                      "article": bloc.article!
                                    }).toString()))
                        ])
                      ]))))
        ]));
  }
}
