class Author {
  final String name;
  final String url;
  final String avatar;
  Author({this.name, this.url, this.avatar});
  Author.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = json['url'],
        avatar = json['avatar'];
  Map<String, dynamic> toJson() => {"name": name, "url": url, "avatar": avatar};
}
