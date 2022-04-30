import 'dart:math';

import 'package:dev_doctor/models/article.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ItemFetcher {
  final _itemsPerPage = 5;
  int _currentPage = 0;
  List<Article> entries = <Article>[];
  final List<String> servers;

  void reset() {
    _currentPage = 0;
  }

  _ItemFetcher({this.servers = const []});

  // This async function simulates fetching results from Internet, etc.
  Future<List<Article>> fetch({required String query}) async {
    if (entries.isEmpty) {
      await Future.wait(Hive.box<String>('servers')
          .values
          .where((element) => servers.contains(element))
          .map((e) async {
        var server = await CoursesServer.fetch(url: e);
        entries.addAll(await server?.fetchArticles() ?? []);
      }));
      entries.sort(
          (a, b) => b.time != null ? a.time?.compareTo(b.time!) ?? -1 : 1);
    }
    final list = <Article>[];
    var n = min(_itemsPerPage, entries.length - _currentPage * _itemsPerPage);
    for (int i = 0; i < n; i++) {
      var index = _currentPage * _itemsPerPage + i;
      var entry = entries[index];
      if (entry.body.toUpperCase().contains(query.toUpperCase()) ||
          entry.title.toUpperCase().contains(query.toUpperCase())) {
        list.add(entry);
      }
    }
    _currentPage++;
    return list;
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final _ItemFetcher _itemFetcher;
  final List<String>? servers;
  final bool gridView;

  CustomSearchDelegate(this._itemFetcher, this.gridView, {this.servers});
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
              "servers.longer".tr(),
            ),
          )
        ],
      );
    }
    return ArticlesList(
        fetcher: _itemFetcher,
        query: query,
        servers: servers,
        gridView: gridView);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}

class _ArticlesPageState extends State<ArticlesPage> {
  late _ItemFetcher _itemFetcher;
  final _box = Hive.box<String>('servers');
  bool gridView = false;
  final List<String> _filteredServers = <String>[];

  @override
  void initState() {
    _filteredServers.addAll(_box.values);
    _itemFetcher = _ItemFetcher(servers: _filteredServers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: "articles.title".tr(), actions: [
          IconButton(
              icon: const Icon(PhosphorIcons.magnifyingGlassLight),
              tooltip: "search".tr(),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(_itemFetcher, gridView),
                );
              }),
          IconButton(
              icon: const Icon(PhosphorIcons.funnelLight),
              tooltip: "articles.filter".tr(),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: const Text("articles.filter").tr(),
                        actions: [
                          TextButton.icon(
                              icon: const Icon(PhosphorIcons.xLight),
                              label: Text("close".tr().toUpperCase()),
                              onPressed: () => Navigator.of(context).pop())
                        ],
                        content: StatefulBuilder(
                            builder: (context, setInnerState) =>
                                SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children:
                                            List.generate(_box.length, (index) {
                                          var url = _box.getAt(index)!;
                                          return CheckboxListTile(
                                              title: Text(url),
                                              value: _filteredServers
                                                  .contains(url),
                                              onChanged: (newValue) {
                                                setInnerState(() {
                                                  newValue!
                                                      ? _filteredServers
                                                          .add(url)
                                                      : _filteredServers
                                                          .remove(url);
                                                });
                                              });
                                        }))))));
                setState(() =>
                    _itemFetcher = _ItemFetcher(servers: _filteredServers));
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
            ArticlesList(fetcher: _itemFetcher, query: "", gridView: gridView));
  }
}

class ArticlesList extends StatefulWidget {
  final _ItemFetcher? fetcher;
  final String query;
  final bool gridView;
  final List<String>? servers;

  const ArticlesList(
      {Key? key,
      this.fetcher,
      required this.query,
      this.servers,
      required this.gridView})
      : super(key: key);
  @override
  _ArticlesListState createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> {
  final _pairList = <Article>[];

  bool _isLoading = true;
  bool _hasMore = true;
  final Box<bool> _favoriteBox = Hive.box<bool>('favorite');
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
    widget.fetcher!
        .fetch(query: widget.query)
        .then((List<Article> fetchedList) {
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
    }).onError((dynamic error, stackTrace) {
      _isLoading = false;
    });
  }

  @override
  void didUpdateWidget(covariant ArticlesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isLoading && oldWidget.fetcher != widget.fetcher) {
      widget.fetcher!.reset();
      _pairList.clear();
      _hasMore = true;
      _loadMore();
    }
  }

  Widget _buildTile(BuildContext context, int index) {
    var article = _pairList[index];

    void onTap() {
      Modular.to.pushNamed(
          Uri(pathSegments: [
            "",
            "articles",
            "details"
          ], queryParameters: {
            "serverId": article.server!.index.toString(),
            "article": article.slug
          }).toString(),
          arguments: article);
    }

    var isFavorite = _favoriteBox.get(article.url, defaultValue: false)!;
    var favorite = IconButton(
        tooltip: "article.like".tr(),
        icon: Icon(
            isFavorite ? PhosphorIcons.heartFill : PhosphorIcons.heartLight),
        onPressed: () {
          _favoriteBox.put(article.url, !isFavorite);
          setState(() {});
        });
    var hero = article.icon.isEmpty
        ? null
        : Hero(
            tag: "Article-icon-${article.server?.index}-${article.slug}",
            child:
                UniversalImage(type: article.icon, url: article.url + "/icon"));
    if (widget.gridView) {
      return Card(
          child: InkWell(
              onTap: onTap,
              child: Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 250,
                    child: Column(children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(8.0), child: hero)),
                      Row(children: [
                        Expanded(
                            child: Column(children: [
                          Text(article.title),
                          Text(article.body,
                              style: Theme.of(context).textTheme.caption)
                        ])),
                        favorite
                      ])
                    ]),
                  ))));
    }
    return ListTile(
        title: Text(article.title),
        subtitle: Text(article.body),
        onTap: onTap,
        trailing: favorite,
        leading: hero);
  }

  List<Widget> _buildList(BuildContext context) {
    return List.generate(
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
}
