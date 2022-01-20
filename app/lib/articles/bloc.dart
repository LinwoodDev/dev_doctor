import 'package:dev_doctor/models/article.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class ArticleBloc extends Disposable {
  BehaviorSubject<Article> articleSubject = BehaviorSubject<Article>();
  String? article;
  @protected
  bool error = false;

  bool get hasError => error;
  ArticleBloc();
  Future<void> fetch(
      {ServerEditorBloc? editorBloc,
      String? server,
      int? serverId,
      String? article,
      int? articleId,
      bool redirectAddServer = true}) async {
    reset();
    try {
      var currentServer = editorBloc != null
          ? editorBloc.server
          : await CoursesServer.fetch(index: serverId, url: server);
      if (editorBloc == null &&
          !(currentServer?.added ?? false) &&
          server != null) {
        Modular.to.pushNamed(Uri(
                pathSegments: ["", "add"],
                queryParameters: {"url": server, "redirect": Modular.to.path})
            .toString());
      }
      if (articleId != null) article = currentServer?.articles[articleId];
      this.article = article;
      var current = article == null
          ? null
          : editorBloc != null
              ? editorBloc.getArticle(article)
              : await currentServer?.fetchArticle(article);
      articleSubject.add(current ?? Article(slug: ''));
      if (current == null) error = true;
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }
      error = true;
    }
  }

  Future<void> fetchFromParams({ServerEditorBloc? editorBloc}) {
    var params = Modular.args.queryParams;
    return fetch(
        editorBloc: editorBloc,
        server: params['server'],
        article: params['article'],
        articleId: int.tryParse(params['articleId'] ?? ''),
        serverId: int.tryParse(params['serverId'] ?? ''));
  }

  void reset() {
    articleSubject = BehaviorSubject<Article>();
    error = false;
  }

  @override
  void dispose() {
    articleSubject.close();
  }
}
