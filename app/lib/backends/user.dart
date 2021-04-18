import 'package:dev_doctor/models/collection.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:easy_localization/easy_localization.dart';

class BackendUserPage extends StatefulWidget {
  final String? user;
  final int? collectionId;
  final Map? model;

  const BackendUserPage({Key? key, this.user, this.collectionId, this.model}) : super(key: key);

  @override
  _BackendUserPageState createState() => _BackendUserPageState();
}

class _BackendUserPageState extends State<BackendUserPage> {
  bool gridView = false;

  Future<BackendUser?> _buildFuture() async {
    if (widget.model != null) return widget.model!['user'];
    var collection = await BackendCollection.fetch(index: widget.collectionId);
    var current = await collection!.fetchUser(widget.user);
    return await current;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.model != null
            ? _buildView(widget.model!['user'], server: widget.model!['server'])
            : FutureBuilder<BackendUser?>(
                future: _buildFuture(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                  var backendUser = snapshot.data!;
                  return _buildView(backendUser);
                }));
  }

  Widget _buildView(BackendUser backendUser, {CoursesServer? server}) {
    var entries = backendUser.buildEntries();
    return Scaffold(
        appBar: MyAppBar(title: backendUser.name, actions: [
          IconButton(
              tooltip: "grid-view".tr(),
              icon: Icon(gridView ? Icons.view_list_outlined : Icons.grid_view),
              onPressed: () {
                setState(() => gridView = !gridView);
              })
        ]),
        body: Scrollbar(
            child: SingleChildScrollView(
                child: gridView
                    ? Wrap(children: _buildList(entries, server: server))
                    : Column(children: _buildList(entries, server: server)))));
  }

  List<Widget> _buildList(List<BackendEntry> entries, {CoursesServer? server}) => List.generate(
      entries.length,
      (index) => server != null && server.url == entries[index].url
          ? _buildTile(server, entries, index)
          : FutureBuilder<CoursesServer?>(
              future: entries[index].fetchServer(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                var server = snapshot.data!;
                return _buildTile(server, entries, index);
              }));

  Widget _buildTile(CoursesServer server, List<BackendEntry> entries, int index) {
    var hero = Hero(
        tag:
            "backend-icon-${server.entry!.collection.index}-${server.entry!.user.name}-${server.entry!.name}",
        child: UniversalImage(url: server.url! + "/icon", type: server.icon));
    void tileTap() => Modular.to.pushNamed(
        "/backends/entry?collectionId=${widget.collectionId}&user=${widget.user}&entry=${entries[index].name}",
        arguments: server);
    return gridView
        ? Card(
            child: InkWell(
                onTap: tileTap,
                child: Container(
                    constraints: BoxConstraints(maxWidth: 250),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      hero,
                      Text(server.name),
                      if (server.url != null)
                        Text(server.url!, style: Theme.of(context).textTheme.caption)
                    ]))))
        : ListTile(
            leading: hero,
            title: Text(server.name),
            subtitle: Text(server.url ?? ''),
            onTap: tileTap);
  }
}
