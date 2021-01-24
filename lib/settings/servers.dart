import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ServersSettingsPage extends StatefulWidget {
  @override
  _ServersSettingsPageState createState() => _ServersSettingsPageState();
}

class _ServersSettingsPageState extends State<ServersSettingsPage> {
  final _serversBox = Hive.box<String>('servers');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Server Settings"),
      body: Container(
          child: ValueListenableBuilder(
              valueListenable: _serversBox.listenable(),
              builder: (context, Box<String> box, _) => FutureBuilder(
                  future: Future.wait(_serversBox.values.map((e) => CoursesServer.fetch(e))),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                        var data = snapshot.data as List<CoursesServer>;
                        return ListView.builder(
                            itemCount: box.length,
                            itemBuilder: (context, index) {
                              var current = data[index];
                              return Dismissible(
                                  // Show a red background as the item is swiped away.
                                  background: Container(color: Colors.red),
                                  key: Key(current.url),
                                  onDismissed: (direction) => _deleteServer(index),
                                  child: ListTile(
                                      title: Text(current.name),
                                      subtitle: Text(current.url),
                                      onLongPress: () => _showDeleteDialog(index)));
                            });
                    }
                  }))),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add server"),
        icon: Icon(Icons.add_outlined),
        onPressed: () => _showDialog(),
      ),
    );
  }

  _showDeleteDialog(int index) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Delete server"),
              content: Text("Do you really want to delete the server ${index + 1}?"),
              actions: [
                FlatButton(child: Text("CANCEL"), onPressed: () => Navigator.of(context).pop()),
                FlatButton(
                  child: Text("DELETE"),
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteServer(index);
                  },
                )
              ],
            ));
  }

  _deleteServer(int index) async {
    await _serversBox.deleteAt(index);
  }

  _createServer(String url) async {
    await _serversBox.add(url);
  }

  _showDialog() {
    var url = '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                contentPadding: const EdgeInsets.all(16.0),
                content: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        onChanged: (value) => url = value,
                        decoration: InputDecoration(
                            labelText: 'URL', hintText: 'eg. https://backend.dev-doctor.cf'),
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                      child: const Text('CANCEL'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  FlatButton(
                      child: const Text('CREATE'),
                      onPressed: () async {
                        Navigator.pop(context);
                        _createServer(url);
                      })
                ]));
  }
}
