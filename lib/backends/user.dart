import 'package:dev_doctor/models/collection.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BackendUserPage extends StatelessWidget {
  final String user;
  final int collectionId;
  final BackendUser model;

  const BackendUserPage({Key key, this.user, this.collectionId, this.model}) : super(key: key);

  Future<BackendUser> _buildFuture() async {
    if (model != null) return model;
    var collection = await BackendCollection.fetch(index: collectionId);
    var current = await collection.fetchUser(user);
    return await current;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: model != null
            ? _buildView(model)
            : FutureBuilder<BackendUser>(
                future: _buildFuture(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                  var backendUser = snapshot.data;
                  return _buildView(backendUser);
                }));
  }

  Widget _buildView(BackendUser backendUser) {
    var entries = backendUser.buildEntries();
    return Scaffold(
        appBar: MyAppBar(title: backendUser.name),
        body: Scrollbar(
            child: SingleChildScrollView(
                child: Wrap(
                    children: List.generate(entries.length, (index) {
          return Container(
              width: 160.0,
              child: FutureBuilder<CoursesServer>(
                  future: entries[index].fetchServer(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                    var server = snapshot.data;
                    return GestureDetector(
                        onTap: () async {
                          await Modular.to.pushNamed(
                              "/backends/entry?collectionId=${collectionId}&user=${user}&entry=${entries[index].name}",
                              arguments: server);
                        },
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(children: [
                              Hero(
                                  tag:
                                      "backend-icon-${server.entry.collection.index}-${server.entry.user.name}-${server.entry.name}",
                                  child: UniversalImage(
                                      url: server.url + "/icon", type: server.icon, width: 160)),
                              Text(server.name)
                            ])));
                  }));
        })))));
  }
}
