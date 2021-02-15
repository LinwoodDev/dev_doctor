import 'dart:convert';
import 'dart:math';

import 'package:dev_doctor/models/server.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class _ItemFetcher {
  final _itemsPerPage = 5;
  int _currentPage = 0;
  List<Map<dynamic, dynamic>> entries = [];

  // This async function simulates fetching results from Internet, etc.
  Future<List<CoursesServer>> fetch() async {
    if (entries.isEmpty)
      await Future.wait(Hive.box<String>('collections').values.map((e) async {
        var value = json.decode((await http.get("$e/metadata/data.json")).body) as List<dynamic>;
        await Future.wait(value.map((user) async {
          var value =
              json.decode((await http.get("$e/metadata/$user/data.json")).body) as List<dynamic>;
          await Future.wait(value.map((entry) async {
            var response = await http.get("$e/metadata/$user/$entry.json");
            var data = json.decode(utf8.decode(response.bodyBytes));
            entries.add(data);
          }));
        }));
      }));
    final list = <CoursesServer>[];
    final n = min(_itemsPerPage, entries.length - _currentPage * _itemsPerPage);
    for (int i = 0; i < n; i++) {
      var index = _currentPage * _itemsPerPage;
      var url = entries[index]['url'];
      var entry = await CoursesServer.fetch(url: url);
      print(entries);
      list.add(entry);
    }
    _currentPage++;
    return list;
  }
}

class BackendsPage extends StatefulWidget {
  @override
  _BackendsPageState createState() => _BackendsPageState();
}

class _BackendsPageState extends State<BackendsPage> {
  final _pairList = <CoursesServer>[];
  final _itemFetcher = _ItemFetcher();

  bool _isLoading = true;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _hasMore = true;
    _loadMore();
  }

  // Triggers fecth() and then add new items or change _hasMore flag
  void _loadMore() {
    _isLoading = true;
    _itemFetcher.fetch().then((List<CoursesServer> fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _pairList.addAll(fetchedList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("backends.title").tr()),
        body: ListView.builder(
          // Need to display a loading tile if more items are coming
          itemCount: _hasMore ? _pairList.length + 1 : _pairList.length,
          itemBuilder: (BuildContext context, int index) {
            // Uncomment the following line to see in real time how ListView.builder works
            // print('ListView.builder is building index $index');
            if (index >= _pairList.length) {
              // Don't trigger if one async loading is already under way
              if (!_isLoading) {
                _loadMore();
              }
              return Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  height: 24,
                  width: 24,
                ),
              );
            }
            var server = _pairList[index];
            return ListTile(
                title: Text(server.name),
                subtitle: Text(server.url),
                trailing: IconButton(
                  icon: Icon(server.added ? Icons.remove_outlined : Icons.add_outlined),
                  onPressed: () async {
                    var toggledServer = await server.toggle();
                    print(Hive.box<String>('servers').values);
                    print(toggledServer.added);
                    setState(() => _pairList[index] = toggledServer);
                  },
                ));
          },
        ));
  }
}
