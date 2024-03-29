import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:hive/hive.dart';

import '../loader.dart';
import 'server.dart';

class BackendCollection {
  final String name;
  final String icon;
  final String url;
  final String type;
  final int? index;

  static Box<String> get _box => Hive.box<String>('collections');
  BackendCollection(
      {required this.name,
      this.icon = "",
      required this.url,
      this.index,
      required this.type});
  BackendCollection.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = json['url'],
        index = (json['index'] != -1) ? json['index'] : null,
        type = json['type'],
        icon = json['icon'];

  static Future<BackendCollection?> fetch({String? url, int? index}) async {
    var data = <String, dynamic>{};
    try {
      if (index == null) {
        var current = _box.values.toList().indexOf(url!);
        if (current != -1) index = _box.keyAt(current);
      } else {
        url ??= _box.get(index);
      }
      var loadedData = await loadFile("$url/config");
      if (loadedData == null) return null;
      data = loadedData;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    data['url'] = url;
    data['index'] = index;
    return BackendCollection.fromJson(data);
  }

  Future<List<String>> fetchUserStrings() async => List<String>.from(
      json.decode((await http.get(Uri.parse("$url/metadata/data.json"))).body)
          as List<dynamic>);
  Future<List<BackendUser>> fetchUsers() => fetchUserStrings()
      .then((value) => Future.wait(value.map((e) => fetchUser(e)).toList()));
  Future<BackendUser> fetchUser(String? user) async => BackendUser.fromJson(json
      .decode((await http.get(Uri.parse("$url/metadata/$user/data.json"))).body)
    ..['collection'] = this
    ..['name'] = user);
}

class BackendUser {
  final BackendCollection collection;
  final String name;
  final Map<String, String> entries;

  BackendUser(
      {required this.name, required this.entries, required this.collection});
  BackendUser.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        collection = json['collection'],
        entries = Map<String, String>.from(json['entries']);

  List<BackendEntry> buildEntries() {
    List<BackendEntry> backendEntries = [];
    entries.forEach((element, url) => backendEntries.add(buildEntry(element)));
    return backendEntries;
  }

  BackendEntry buildEntry(String entry) => BackendEntry(
      collection: collection, name: entry, url: entries[entry]!, user: this);
}

class BackendEntry {
  final BackendCollection collection;
  final BackendUser user;
  final String name;
  final String url;

  BackendEntry(
      {required this.collection,
      required this.user,
      required this.name,
      required this.url});
  BackendEntry.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        user = json['user'],
        url = json['url'],
        collection = json['collection'];

  Future<CoursesServer?> fetchServer() =>
      CoursesServer.fetch(url: url, entry: this);
}
