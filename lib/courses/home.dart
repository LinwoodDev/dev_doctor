import 'dart:math';

import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:easy_localization/easy_localization.dart';

class CoursesPage extends StatefulWidget {
  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _ItemFetcher {
  final _itemsPerPage = 5;
  int _currentPage = 0;
  List<Course> entries = <Course>[];

  // This async function simulates fetching results from Internet, etc.
  Future<List<Course>> fetch({String query}) async {
    if (entries.isEmpty)
      await Future.wait(Hive.box<String>('servers').values.map((e) async {
        var server = await CoursesServer.fetch(url: e);
        entries.addAll(await server.fetchCourses());
      }));
    final list = <Course>[];
    var n = min(_itemsPerPage, entries.length - _currentPage * _itemsPerPage);
    for (int i = 0; i < n; i++) {
      var index = _currentPage * _itemsPerPage + i;
      var entry = entries[index];
      if ((entry.body != null && entry.body.toUpperCase().contains(query.toUpperCase())) ||
          entry.name.toUpperCase().contains(query.toUpperCase())) list.add(entry);
    }
    print(list.map((e) => e.description));
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
              "servers.longer".tr(),
            ),
          )
        ],
      );
    }
    _itemFetcher = _ItemFetcher();
    return CoursesList(fetcher: _itemFetcher, query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}

class _CoursesPageState extends State<CoursesPage> {
  final _itemFetcher = _ItemFetcher();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("courses.title").tr(), actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(_itemFetcher),
                );
              })
        ]),
        body: CoursesList(fetcher: _itemFetcher, query: ""));
  }
}

class CoursesList extends StatefulWidget {
  final _ItemFetcher fetcher;
  final String query;

  const CoursesList({Key key, this.fetcher, this.query}) : super(key: key);
  @override
  _CoursesListState createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  final _pairList = <Course>[];

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
    widget.fetcher.fetch(query: widget.query).then((List<Course> fetchedList) {
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
  void didUpdateWidget(covariant CoursesList oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
        var course = _pairList[index];
        return ListTile(
            title: Text(course.name),
            subtitle: Text(course.description),
            onTap: () => Modular.to.pushNamed(
                "/courses/details?serverId=${course.server.index}&courseId=${course.index}"),
            leading: course.icon?.isEmpty ?? true
                ? null
                : UniversalImage(type: course.icon, url: course.url + "/icon"));
      },
    );
  }
}
