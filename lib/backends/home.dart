import 'dart:convert';
import 'dart:math';

import 'package:dev_doctor/models/collection.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class _ItemFetcher {
  final _itemsPerPage = 5;
  int _currentPage = 0;
  List<BackendEntry> entries = <BackendEntry>[];

  // This async function simulates fetching results from Internet, etc.
  Future<List<CoursesServer>> fetch() async {
    if (entries.isEmpty)
      await Future.wait(Hive.box<String>('collections').values.map((e) async {
        var collection = await BackendCollection.fetch(url: e);
        entries.addAll(await collection.fetchEntries());
      }));
    final list = <CoursesServer>[];
    final n = min(_itemsPerPage, entries.length - _currentPage * _itemsPerPage);
    for (int i = 0; i < n; i++) {
      var index = _currentPage * _itemsPerPage;
      var entry = entries[index];
      var server = await entry.fetchServer();
      list.add(server);
    }
    _currentPage++;
    return list;
  }
}

class BackendsPage extends StatefulWidget {
  @override
  _BackendsPageState createState() => _BackendsPageState();
}

class _BackendsPageState extends State<BackendsPage> with TickerProviderStateMixin {
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
            return BackendEntryListTile(server: server);
          },
        ));
  }
}

class BackendEntryListTile extends StatefulWidget {
  final CoursesServer server;
  final int backendId;
  final String user;
  final String entry;

  const BackendEntryListTile({Key key, this.server, this.backendId, this.user, this.entry})
      : super(key: key);
  @override
  _BackendEntryListTileState createState() => _BackendEntryListTileState();
}

class _BackendEntryListTileState extends State<BackendEntryListTile>
    with SingleTickerProviderStateMixin {
  CoursesServer _server;
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _server = widget.server;
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animation = Tween<double>(begin: 0, end: 0.25).animate(_controller);
    return ListTile(
        title: Text(_server.name),
        subtitle: Text(_server.url),
        onTap: () => Modular.to.pushNamed(
            "/backends/details?collectionId=${_server.entry.collection.index}&user=${_server.entry.user}&entry=${_server.entry.name}",
            arguments: _server),
        leading: _server.icon?.isEmpty ?? true
            ? null
            : UniversalImage(type: _server.icon, url: _server.url + "/icon"),
        trailing: RotationTransition(
            turns: _animation,
            child: IconButton(
              icon: Icon(_server.added ? Icons.remove_outlined : Icons.add_outlined),
              onPressed: () async {
                var toggledServer = await _server.toggle();
                setState(() {
                  _server = toggledServer;
                });
                if (_server.added)
                  _controller.reverse();
                else
                  _controller.forward();
              },
            )));
  }
}
