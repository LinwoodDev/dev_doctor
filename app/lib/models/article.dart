import 'author.dart';
import 'server.dart';

class Article {
  final DateTime? time;
  final String title;
  final String slug;
  final String icon;
  final List<String> keywords;
  final String body;
  final String description;
  final CoursesServer? server;
  final Author author;

  Article(
      {required this.slug,
      this.title = "",
      this.keywords = const [],
      this.body = "",
      this.description = "",
      this.time,
      this.author = const Author(),
      this.server,
      this.icon = ""});

  Article.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        slug = json['slug'],
        body = json['body'] ?? "",
        description = json['description'] ?? "",
        keywords = json['keywords'] ?? [],
        time = DateTime.tryParse(json['time'] ?? ""),
        author = Author.fromJson(Map<String, dynamic>.from(json['author'] ?? {})),
        server = json['server'],
        icon = json['icon'] ?? "";

  Map<String, dynamic> toJson() =>
      {"title": title, "body": body, "keywords": keywords, "time": time?.toString()};

  Article copyWith(
          {DateTime? time,
          String? title,
          String? slug,
          String? icon,
          List<String>? keywords,
          String? body,
          Author? author,
          bool clearTime = false}) =>
      Article(
          slug: slug ?? this.slug,
          author: author ?? this.author,
          body: body ?? this.body,
          icon: icon ?? this.icon,
          keywords: keywords ?? this.keywords,
          server: server,
          time: clearTime ? null : time ?? this.time,
          title: title ?? this.title);

  get url => server!.url + "/" + slug + (server?.type ?? "");
}
