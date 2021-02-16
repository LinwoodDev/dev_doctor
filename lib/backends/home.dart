import 'dart:math';

import 'package:dev_doctor/models/collection.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';

class _ItemFetcher {
  final _itemsPerPage = 5;
  int _currentPage = 0;
  List<BackendEntry> entries = <BackendEntry>[];

  // This async function simulates fetching results from Internet, etc.
  Future<List<CoursesServer>> fetch({String query}) async {
    if (entries.isEmpty)
      await Future.wait(Hive.box<String>('collections').values.map((e) async {
        var collection = await BackendCollection.fetch(url: e);
        entries.addAll((await collection.fetchUsers()).expand((e) => e.buildEntries()));
      }));
    final list = <CoursesServer>[];
    var n = min(_itemsPerPage, entries.length - _currentPage * _itemsPerPage);
    for (int i = 0; i < n; i++) {
      var index = _currentPage * _itemsPerPage + i;
      var entry = entries[index];
      var server = await entry.fetchServer();
      if ((server.body != null && server.body.toUpperCase().contains(query.toUpperCase())) ||
          server.name.toUpperCase().contains(query.toUpperCase())) list.add(server);
    }
    _currentPage++;
    return list;
  }
}

class CustomSearchDelegate extends SearchDelegate {
  var _itemFetcher;

  CustomSearchDelegate(this._itemFetcher);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "backends.longer".tr(),
            ),
          )
        ],
      );
    }
    _itemFetcher = _ItemFetcher();
    return BackendsList(
      fetcher: _itemFetcher,
      query: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}

class BackendsList extends StatefulWidget {
  final _ItemFetcher fetcher;
  final String query;

  const BackendsList({Key key, this.fetcher, this.query}) : super(key: key);
  @override
  _BackendsListState createState() => _BackendsListState();
}

class _BackendsListState extends State<BackendsList> {
  final _pairList = <CoursesServer>[];

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
    widget.fetcher.fetch(query: widget.query).then((List<CoursesServer> fetchedList) {
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
  void didUpdateWidget(covariant BackendsList oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.builder(
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

class BackendsPage extends StatefulWidget {
  @override
  _BackendsPageState createState() => _BackendsPageState();
}

class _BackendsPageState extends State<BackendsPage> with TickerProviderStateMixin {
  final _itemFetcher = _ItemFetcher();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("backends.title").tr(), actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(_itemFetcher),
                );
              })
        ]),
        body: BackendsList(fetcher: _itemFetcher, query: ""));
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

class _BackendEntryListTileState extends State<BackendEntryListTile> {
  CoursesServer _server;
  @override
  void initState() {
    super.initState();
    if (_server == null) _server = widget.server;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(_server.name),
        subtitle: Text(_server.url),
        onTap: () async {
          await Modular.to.pushNamed(
              "/backends/details?collectionId=${_server.entry.collection.index}&user=${_server.entry.user}&entry=${_server.entry.name}",
              arguments: _server);
          var current = await _server.entry.fetchServer();
          setState(() => _server = current);
        },
        leading: _server.icon?.isEmpty ?? true
            ? null
            : UniversalImage(type: _server.icon, url: _server.url + "/icon"),
        trailing: AddBackendButton(
            server: _server, onChange: (server) => setState(() => _server = server)));
  }
}

typedef OnBackendChanged = void Function(CoursesServer server);

class AddBackendButton extends StatefulWidget {
  final CoursesServer server;
  final OnBackendChanged onChange;

  const AddBackendButton({Key key, this.server, this.onChange}) : super(key: key);
  @override
  _AddBackendButtonState createState() => _AddBackendButtonState();
}

class _AddBackendButtonState extends State<AddBackendButton> with SingleTickerProviderStateMixin {
  CoursesServer _server;
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if (_server == null) _server = widget.server;
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AddBackendButton oldWidget) {
    _server = widget.server;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _animation = Tween<double>(begin: 0, end: 0.25).animate(_controller);
    return RotationTransition(
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
            if (widget.onChange != null) return widget.onChange(toggledServer);
          },
        ));
  }
}
