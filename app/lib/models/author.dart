class Author {
  final String name;
  final String url;
  final String avatar;
  final String avatarType;
  const Author({this.name = "", this.url = "", this.avatar = "", this.avatarType = 'png'});
  Author.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? "",
        url = json['url'] ?? "",
        avatar = json['avatar'] ?? "",
        avatarType = json['avatar-type'] ?? 'png';
  Map<String, dynamic> toJson(int? apiVersion) =>
      {"api-version": apiVersion, "name": name, "url": url, "avatar": avatar};

  Author copyWith({String? avatar, String? name, String? url, String? avatarType}) => Author(
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      url: url ?? this.url,
      avatarType: avatarType ?? this.avatarType);
}
