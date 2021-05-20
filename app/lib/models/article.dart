class Article {
  final DateTime? time;
  final String name;
  final List<String> keywords;
  final String description;

  Article({required this.name, this.keywords = const [], this.description = "", this.time});

  Article.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'] ?? "",
        keywords = json['keywords'] ?? [],
        time = DateTime.tryParse(json['time']);

  Map<String, dynamic> toJson() =>
      {"name": name, "description": description, "keywords": keywords, "time": time?.toString()};
}
