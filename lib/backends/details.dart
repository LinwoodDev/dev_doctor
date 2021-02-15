import 'package:dev_doctor/models/collection.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

import 'home.dart';

class BackendPage extends StatefulWidget {
  final String user;
  final String entry;
  final int collectionId;
  final CoursesServer model;

  const BackendPage({Key key, this.user, this.entry, this.collectionId, this.model})
      : super(key: key);

  @override
  _BackendPageState createState() => _BackendPageState();
}

class _BackendPageState extends State<BackendPage> {
  Future<CoursesServer> _buildFuture() async {
    if (widget.model != null) return widget.model;
    var collection = await BackendCollection.fetch(index: widget.collectionId);
    var entry = await collection.fetchEntry(user: widget.user, entry: widget.entry);
    return await entry.fetchServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<CoursesServer>(
            future: _buildFuture(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                  var server = snapshot.data;
                  return NestedScrollView(
                      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            expandedHeight: 400.0,
                            floating: false,
                            pinned: true,
                            actions: [AddBackendButton(server: server)],
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              title: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withAlpha(200),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(server.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ))),
                              background: Container(
                                  margin: EdgeInsets.fromLTRB(10, 20, 10, 84),
                                  child: UniversalImage(
                                    url: server.url + "/icon",
                                    height: 500,
                                    type: server.icon,
                                  )),
                            ),
                          )
                        ];
                      },
                      body: ListView(
                        children: <Widget>[
                          if (server.body != null)
                            Padding(
                                padding: EdgeInsets.all(16),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16)),
                                    child: Padding(
                                        padding: const EdgeInsets.all(64.0),
                                        child: MarkdownBody(
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
                                        )))),
                        ],
                      ));
              }
            }));
  }
}
