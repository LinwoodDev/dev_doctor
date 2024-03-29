import 'package:dev_doctor/articles/bloc.dart';
import 'package:dev_doctor/articles/details.dart';
import 'package:dev_doctor/backends/entry.dart';
import 'package:dev_doctor/courses/bloc.dart';
import 'package:dev_doctor/courses/details.dart';
import 'package:dev_doctor/editor/author.dart';
import 'package:dev_doctor/editor/part.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/widgets/error.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home.dart';
import 'markdown.dart';

class EditorModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => const EditorPage()),
        WildcardRoute(child: (_, __) => const ErrorDisplay()),
        ChildRoute('/details', child: (_, args) {
          if (!args.queryParams.containsKey('serverId')) {
            return const ErrorDisplay();
          }
          var bloc = ServerEditorBloc.fromKey(
              int.parse(args.queryParams['serverId']!));
          return BackendPage(editorBloc: bloc);
        }),
        ChildRoute('/edit', child: (_, args) {
          if (!args.queryParams.containsKey('serverId')) {
            return const ErrorDisplay();
          }
          var bloc = ServerEditorBloc.fromKey(
              int.parse(args.queryParams['serverId']!));
          return MarkdownEditor(
              markdown: bloc.server.body,
              onSubmit: (value) {
                bloc.server = bloc.server.copyWith(body: value);
                bloc.save();
              });
        }),
        ChildRoute('/article', child: (_, args) {
          if (!args.queryParams.containsKey('serverId')) {
            return const ErrorDisplay();
          }
          var bloc = ServerEditorBloc.fromKey(
              int.parse(args.queryParams['serverId']!));
          return ArticlePage(editorBloc: bloc);
        }),
        ChildRoute('/article/edit', child: (_, args) {
          if (!args.queryParams.containsKey('serverId')) {
            return const ErrorDisplay();
          }
          var bloc = ServerEditorBloc.fromKey(
              int.parse(args.queryParams['serverId']!));
          var articleName = args.queryParams['article'];
          var article = bloc.getArticle(articleName!);
          return MarkdownEditor(
              markdown: article.body,
              onSubmit: (value) {
                article = article.copyWith(body: value);
                bloc.updateArticle(article);
                Modular.get<ArticleBloc>().articleSubject.add(article);
                bloc.save();
              });
        }),
        ChildRoute('/article/author', child: (_, args) {
          if (!args.queryParams.containsKey('serverId')) {
            return const ErrorDisplay();
          }
          var bloc = ServerEditorBloc.fromKey(
              int.parse(args.queryParams['serverId']!));
          var article = bloc.getArticle(args.queryParams['article']!);
          return AuthorEditingPage(
              author: article.author,
              onSubmit: (value) {
                article = article.copyWith(author: value);
                bloc.updateArticle(article);
                Modular.get<ArticleBloc>().articleSubject.add(article);
                bloc.save();
              });
        }),
        ChildRoute('/course', child: (_, args) {
          if (!args.queryParams.containsKey('serverId')) {
            return const ErrorDisplay();
          }
          var bloc = ServerEditorBloc.fromKey(
              int.parse(args.queryParams['serverId']!));
          return CoursePage(editorBloc: bloc);
        }),
        ChildRoute('/course/edit', child: (_, args) {
          if (!args.queryParams.containsKey('serverId')) {
            return const ErrorDisplay();
          }
          var bloc = ServerEditorBloc.fromKey(
              int.parse(args.queryParams['serverId']!));
          var course = args.queryParams['course'];
          var courseBloc = bloc.getCourse(course!);
          return MarkdownEditor(
              markdown: courseBloc.course.body,
              onSubmit: (value) {
                courseBloc.course = courseBloc.course.copyWith(body: value);
                bloc.save();
              });
        }),
        ChildRoute('/course/author', child: (_, args) {
          if (!args.queryParams.containsKey('serverId')) {
            return const ErrorDisplay();
          }
          var bloc = ServerEditorBloc.fromKey(
              int.parse(args.queryParams['serverId']!));
          var course = args.queryParams['course'];
          var courseBloc = bloc.getCourse(course!);
          return AuthorEditingPage(
              author: courseBloc.course.author,
              onSubmit: (value) {
                courseBloc.course = courseBloc.course.copyWith(author: value);
                bloc.save();
              });
        }),
        ModuleRoute('/course/item', module: EditorPartModule())
      ];
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton((i) => CourseBloc()),
        Bind.singleton((i) => ArticleBloc())
      ];
}
