import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/system_padding.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ServersSettingsPage extends StatefulWidget {
  @override
  _ServersSettingsPageState createState() => _ServersSettingsPageState();
}

class _ServersSettingsPageState extends State<ServersSettingsPage> {
  final _settingsBox = Hive.box('settings');
  List<dynamic> _servers;
  @override
  void initState() {
    _servers = _settingsBox.get('servers', defaultValue: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Server Settings"),
      body: Container(
          child: ListView.builder(
        itemCount: _servers.length,
        itemBuilder: (context, index) =>
            ListTile(title: Text(_servers[index]), onLongPress: () => _showDeleteDialog(index)),
      )),
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
    List<dynamic> current = _servers;
    current.removeAt(index);
    await _settingsBox.put('servers', current);
    setState(() => _servers = current);
  }

  _createServer(String url) async {
    var current = _servers;
    current.add(url);
    await _settingsBox.put('servers', current);
    setState(() => _servers = current);
  }

  _showDialog() {
    var url = '';
    showDialog(
      context: context,
      builder: (context) => SystemPadding(
        child: AlertDialog(
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
          ],
        ),
      ),
    );
  }
}
