import 'dart:math';

import 'package:dev_doctor/models/collection.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class _ItemFetcher {
  final _itemsPerPage = 5;
  int _currentPage = 0;
  List<BackendEntry> entries = <BackendEntry>[];

  // This async function simulates fetching results from Internet, etc.
  Future<List<CoursesServer>> fetch(String query) async {
    if (entries.isEmpty) {
      await Future.wait(Hive.box<String>('collections').values.map((e) async {
        var collection = await BackendCollection.fetch(url: e);
        var users = await collection?.fetchUsers();
        entries.addAll(users?.expand((e) => e.buildEntries()) ?? []);
      }));
    }
    final list = <CoursesServer>[];
    var n = min(_itemsPerPage, entries.length - _currentPage * _itemsPerPage);
    for (int i = 0; i < n; i++) {
      var index = _currentPage * _itemsPerPage + i;
      var entry = entries[index];
      var server = await entry.fetchServer();
      if ((server!.body.isNotEmpty &&
              server.body.toUpperCase().contains(query.toUpperCase())) ||
          server.name.toUpperCase().contains(query.toUpperCase())) {
        list.add(server);
      }
    }
    _currentPage++;
    return list;
  }
}

class CustomSearchDelegate extends SearchDelegate {
  _ItemFetcher _itemFetcher;
  final bool gridView;

  CustomSearchDelegate(this._itemFetcher, this.gridView);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: "clear".tr(),
        icon: const Icon(PhosphorIcons.xLight),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: "back".tr(),
      icon: const Icon(PhosphorIcons.arrowArcLeftLight),
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
        fetcher: _itemFetcher, query: query, gridView: gridView);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}

class BackendsList extends StatefulWidget {
  final _ItemFetcher? fetcher;
  final String query;
  final bool gridView;

  const BackendsList(
      {Key? key, this.fetcher, this.query = "", required this.gridView})
      : super(key: key);
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
    widget.fetcher!.fetch(widget.query).then((List<CoursesServer> fetchedList) {
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
    return Scrollbar(
        child: SingleChildScrollView(
            child: widget.gridView
                ? Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Wrap(children: _buildList(context)))
                : Column(
                    // Need to display a loading tile if more items are coming
                    children: _buildList(context))));
  }

  List<Widget> _buildList(BuildContext context) => List.generate(
        // Need to display a loading tile if more items are coming
        _hasMore ? _pairList.length + 1 : _pairList.length,
        (index) {
          // Uncomment the following line to see in real time how ListView.builder works
          if (index >= _pairList.length) {
            // Don't trigger if one async loading is already under way
            if (!_isLoading) {
              _loadMore();
            }
            return const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return _buildTile(context, index);
        },
      );

  Widget _buildTile(BuildContext context, int index) {
    var server = _pairList[index];
    void onTap() async {
      await Modular.to.pushNamed(
          "/backends/entry?collectionId=${server.entry!.collection.index}&user=${server.entry!.user.name}&entry=${server.entry!.name}",
          arguments: server);
      var current = await server.entry!.fetchServer();
      if (current != null) setState(() => _pairList[index] = current);
    }

    var hero = server.icon.isEmpty
        ? null
        : Hero(
            tag:
                "backend-icon-${server.entry!.collection.index}-${server.entry!.user.name}-${server.entry!.name}",
            child:
                UniversalImage(type: server.icon, url: "${server.url}/icon"));

    if (widget.gridView) {
      return Card(
          child: InkWell(
              onTap: onTap,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 250),
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Container(padding: const EdgeInsets.all(8.0), child: hero),
                  Row(children: [
                    Expanded(
                        child: Column(children: [
                      Text(server.name),
                      Text(server.url,
                          style: Theme.of(context).textTheme.caption)
                    ])),
                    AddBackendButton(server: server)
                  ])
                ]),
              )));
    }

    return ListTile(
        title: Text(server.name),
        subtitle: Text(server.url),
        onTap: onTap,
        leading: hero,
        trailing: AddBackendButton(server: server));
  }
}

class BackendsPage extends StatefulWidget {
  const BackendsPage({Key? key}) : super(key: key);

  @override
  _BackendsPageState createState() => _BackendsPageState();
}

class _BackendsPageState extends State<BackendsPage>
    with TickerProviderStateMixin {
  final _itemFetcher = _ItemFetcher();
  bool gridView = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: "backends.title".tr(), actions: [
          IconButton(
              tooltip: "search".tr(),
              icon: const Icon(PhosphorIcons.magnifyingGlassLight),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(_itemFetcher, gridView));
              }),
          IconButton(
              tooltip: "grid-view".tr(),
              icon: Icon(gridView
                  ? PhosphorIcons.listLight
                  : PhosphorIcons.squaresFourLight),
              onPressed: () {
                setState(() => gridView = !gridView);
              })
        ]),
        body:
            BackendsList(fetcher: _itemFetcher, query: "", gridView: gridView));
  }
}

typedef OnBackendChanged = void Function(CoursesServer server);

class AddBackendButton extends StatefulWidget {
  final CoursesServer server;
  final OnBackendChanged? onChange;

  const AddBackendButton({Key? key, required this.server, this.onChange})
      : super(key: key);
  @override
  _AddBackendButtonState createState() => _AddBackendButtonState();
}

class _AddBackendButtonState extends State<AddBackendButton>
    with SingleTickerProviderStateMixin {
  late CoursesServer _server;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _server = widget.server;
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        value: _server.added ? 1 : 0);
    _animation = Tween<double>(begin: -0.25, end: 0).animate(_controller);
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
    return RotationTransition(
        turns: _animation,
        child: IconButton(
          tooltip:
              (_server.added ? "backends.uninstall" : "backends.install").tr(),
          icon: Icon(_server.added
              ? PhosphorIcons.minusLight
              : PhosphorIcons.plusLight),
          onPressed: () async {
            var toggledServer = await _server.toggle();
            (_server.added ? _controller.reverse() : _controller.forward())
                .then((value) => setState(() => _server = toggledServer));
            if (widget.onChange != null) return widget.onChange!(toggledServer);
          },
        ));
  }
}
