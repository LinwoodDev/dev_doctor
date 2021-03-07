import 'package:dev_doctor/editor/bloc/server.dart';
import 'package:dev_doctor/models/collection.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

import 'home.dart';

class BackendPage extends StatelessWidget {
  final String user;
  final String entry;
  final int collectionId;
  final CoursesServer model;
  final ServerEditorBloc editorBloc;

  const BackendPage(
      {Key key, this.user, this.entry, this.collectionId, this.model, this.editorBloc})
      : super(key: key);

  Future<CoursesServer> _buildFuture() async {
    if (model != null) return model;
    var collection = await BackendCollection.fetch(index: collectionId);
    var currentUser = await collection.fetchUser(user);
    var currentEntry = currentUser.buildEntry(entry);
    var server = await currentEntry.fetchServer();
    return server;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: model != null
            ? _buildView(model)
            : editorBloc != null
                ? _buildView(editorBloc.server)
                : FutureBuilder<CoursesServer>(
                    future: _buildFuture(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                          var server = snapshot.data;
                          return _buildView(server);
                      }
                    }));
  }

  Widget _buildView(CoursesServer server) => Builder(
      builder: (context) => DefaultTabController(
          length: 2,
          child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 400.0,
                    floating: false,
                    pinned: true,
                    actions: [AddBackendButton(server: server)],
                    bottom: TabBar(tabs: [Tab(text: "General"), Tab(text: "Courses")]),
                    title: Text(server.name),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 84),
                          child: Hero(
                              tag:
                                  "backend-icon-${server.entry.collection.index}-${server.entry.user.name}-${server.entry.name}",
                              child: UniversalImage(
                                url: server.url + "/icon",
                                height: 500,
                                type: server.icon,
                              ))),
                    ),
                  )
                ];
              },
              body: Scrollbar(
                  child: ListView(
                children: <Widget>[
                  if (server.body != null)
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                                padding: const EdgeInsets.all(64.0),
                                child:
                                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: TextButton.icon(
                                          onPressed: () async => await Modular.to.pushNamed(
                                              "/backends/user?collectionId=${collectionId}&user=${user}",
                                              arguments: server.entry.user),
                                          icon: Icon(Icons.account_circle_outlined),
                                          label: Text(user))),
                                  MarkdownBody(
                                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                                    onTapLink: (_, url, __) => launch(url),
                                    extensionSet: md.ExtensionSet(
                                      md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                                      [
                                        md.EmojiSyntax(),
                                        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                                      ],
                                    ),
                                    data: server.body,
                                    selectable: true,
                                  )
                                ]))))
                ],
              )))));
}
