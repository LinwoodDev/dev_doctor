import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import 'layout.dart';

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
      appBar: MyAppBar(title: "settings.servers.title".tr()),
      body: SettingsLayout(
          child: ValueListenableBuilder(
              valueListenable: _serversBox.listenable(),
              builder: (context, Box<String> box, _) => FutureBuilder(
                  future: Future.wait(_serversBox.values
                      .toList()
                      .asMap()
                      .map((index, e) => MapEntry(index, CoursesServer.fetch(url: e, index: index)))
                      .values),
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
                                      leading: current.icon?.isEmpty ?? true
                                          ? null
                                          : UniversalImage(
                                              type: current.icon, url: current.url + "/icon"),
                                      title: Text(current.name ?? 'settings.servers.error'.tr()),
                                      subtitle: Text(current.url)));
                            });
                    }
                  }))),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("settings.servers.add.fab").tr(),
        icon: Icon(Icons.add_outlined),
        onPressed: () => _showDialog(),
      ),
    );
  }

  _deleteServer(int index) async {
    await _serversBox.deleteAt(index);
  }

  _createServer(String url) async {
    var server = await CoursesServer.fetch(url: url);
    if (server.name == null)
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("settings.servers.error").tr(),
                actions: [
                  TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close_outlined),
                      label: Text("close".tr().toUpperCase()))
                ],
              ));
    else
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
                            labelText: 'settings.servers.add.url'.tr(),
                            hintText: 'settings.servers.add.hint'.tr()),
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      child: Text('settings.servers.add.cancel'.tr().toUpperCase()),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  TextButton(
                      child: Text('settings.servers.add.create'.tr().toUpperCase()),
                      onPressed: () async {
                        Navigator.pop(context);
                        _createServer(url);
                      })
                ]));
  }
}
