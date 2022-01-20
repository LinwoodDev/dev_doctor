import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'home.dart';
import 'layout.dart';

class ServersSettingsPage extends StatefulWidget {
  const ServersSettingsPage({Key? key}) : super(key: key);

  @override
  _ServersSettingsPageState createState() => _ServersSettingsPageState();
}

class _ServersSettingsPageState extends State<ServersSettingsPage> {
  final _serversBox = Hive.box<String>('servers');
  @override
  void initState() {
    super.initState();
  }

  Future<List<CoursesServer?>> _buildFuture() async {
    var urls = _serversBox.values.toList().asMap();
    var servers = <CoursesServer?>[];
    for (var key in urls.keys) {
      var value = urls[key];
      servers.add((await CoursesServer.fetch(url: value, index: key)));
    }
    return servers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "settings.servers.title".tr()),
      body: SettingsLayout(
          activePage: SettingsPages.servers,
          child: ValueListenableBuilder(
              valueListenable: _serversBox.listenable(),
              builder: (context, Box<String> box, _) => FutureBuilder<
                      List<CoursesServer?>>(
                  future: _buildFuture(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        var data = snapshot.data;
                        return Scrollbar(
                            child: ListView.builder(
                                itemCount: box.length,
                                itemBuilder: (context, index) {
                                  var current = data?[index];
                                  return Dismissible(
                                      // Show a red background as the item is swiped away.
                                      background: Container(color: Colors.red),
                                      key: Key(box.getAt(index)!),
                                      onDismissed: (direction) =>
                                          _deleteServer(index),
                                      child: ListTile(
                                          leading: current?.icon.isEmpty ??
                                                  current == null
                                              ? null
                                              : UniversalImage(
                                                  type: current!.icon,
                                                  url: current.url + "/icon"),
                                          title: Text(current?.name ??
                                              "settings.servers.error".tr()),
                                          subtitle: Text(current?.url ?? "")));
                                }));
                    }
                  }))),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("settings.servers.add.fab").tr(),
        icon: const Icon(PhosphorIcons.plusLight),
        onPressed: () => _showDialog(),
      ),
    );
  }

  _deleteServer(int index) async {
    await _serversBox.deleteAt(index);
  }

  _createServer(String url) async {
    var server = await CoursesServer.fetch(url: url);
    if (server == null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("settings.servers.error").tr(),
                actions: [
                  TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(PhosphorIcons.xLight),
                      label: Text("close".tr().toUpperCase()))
                ],
              ));
    } else {
      await _serversBox.add(url);
    }
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
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                            labelText: 'settings.servers.add.url'.tr(),
                            hintText: 'settings.servers.add.hint'.tr()),
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      child: Text('cancel'.tr().toUpperCase()),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  TextButton(
                      child: Text('create'.tr().toUpperCase()),
                      onPressed: () async {
                        Navigator.pop(context);
                        _createServer(url);
                      })
                ]));
  }
}
