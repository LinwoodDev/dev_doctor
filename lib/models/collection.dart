import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:hive/hive.dart';

import '../loader.dart';
import 'server.dart';

class BackendCollection {
  final String name;
  final String icon;
  final String url;
  final String type;
  final int index;

  static Box<String> get _box => Hive.box<String>('collections');
  BackendCollection({this.name, this.icon, this.url, this.index, this.type});
  BackendCollection.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = json['url'],
        index = (json['index'] != -1) ? json['index'] : null,
        type = json['type'],
        icon = json['icon'];

  static Future<BackendCollection> fetch({String url, int index}) async {
    var data = Map<String, dynamic>();
    try {
      if (index == null) {
        var current = _box.values.toList().indexOf(url);
        if (current != -1) index = _box.keyAt(current);
      } else if (url == null) url = _box.get(index);
      data = await loadFile("$url/config");
    } catch (e) {
      print(e);
    }
    data['url'] = url;
    data['index'] = index;
    return BackendCollection.fromJson(data);
  }

  Future<List<String>> fetchUsers() async => List<String>.from(
      json.decode((await http.get("$url/metadata/data.json")).body) as List<dynamic>);

  Future<List<String>> fetchEntriesString({String user}) async {
    List<String> entries = <String>[];
    await Future.wait((user == null ? await fetchUsers() : <String>[user]).map((current) async =>
        entries.addAll(List<String>.from(
            json.decode((await http.get("$url/metadata/$current/data.json")).body)))));
    return entries;
  }

  Future<List<BackendEntry>> fetchEntries({String user}) async {
    var users = await fetchUsers();
    var entries = <BackendEntry>[];
    await Future.wait(users.map((user) async {
      var userEntries = await fetchEntriesString(user: user);
      await Future.wait(
          userEntries.map((e) async => entries.add(await fetchEntry(user: user, entry: e))));
    }));
    return entries;
  }

  Future<BackendEntry> fetchEntry({String user, String entry}) async {
    var data =
        json.decode(utf8.decode((await http.get("$url/metadata/$user/$entry.json")).bodyBytes));
    data['user'] = user;
    data['name'] = entry;
    data['collection'] = this;
    return BackendEntry.fromJson(data);
  }
}

class BackendEntry {
  final BackendCollection collection;
  final String user;
  final String name;
  final String url;

  BackendEntry({this.collection, this.user, this.name, this.url});
  BackendEntry.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        user = json['user'],
        url = json['url'],
        collection = json['collection'];

  Future<CoursesServer> fetchServer() => CoursesServer.fetch(url: url, entry: this);
}
