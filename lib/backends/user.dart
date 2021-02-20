import 'package:dev_doctor/models/collection.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BackendUserPage extends StatefulWidget {
  final String user;
  final int collectionId;
  final BackendUser model;

  const BackendUserPage({Key key, this.user, this.collectionId, this.model}) : super(key: key);

  @override
  _BackendUserPageState createState() => _BackendUserPageState();
}

class _BackendUserPageState extends State<BackendUserPage> {
  Future<BackendUser> _buildFuture() async {
    if (widget.model != null) return widget.model;
    var collection = await BackendCollection.fetch(index: widget.collectionId);
    var user = await collection.fetchUser(widget.user);
    return await user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.model != null
            ? _buildView(widget.model)
            : FutureBuilder<BackendUser>(
                future: _buildFuture(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                      var user = snapshot.data;
                      return _buildView(user);
                  }
                }));
  }

  Widget _buildView(BackendUser user) {
    var entries = user.entries.keys.toList();
    print(user.entries.toString());
    return Scaffold(
        appBar: AppBar(title: Text(user.name)),
        body: Scrollbar(
            child: SingleChildScrollView(
                child: Wrap(
                    children: List.generate(entries.length, (index) {
          return Container(
              width: 160.0,
              child: FutureBuilder<CoursesServer>(
                  future: user.buildEntry(entries[index]).fetchServer(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                        var server = snapshot.data;
                        print(server);
                        return InkWell(
                            onTap: () => Modular.to.pushNamed(
                                "/backends/entry?collectionId=${widget.collectionId}&user=${widget.user}&entry=${entries[index]}"),
                            child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(children: [
                                  UniversalImage(
                                      url: server.url + "/icon", type: server.icon, width: 160),
                                  Text(server.name)
                                ])));
                    }
                  }));
        })))));
  }
}
