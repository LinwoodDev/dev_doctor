import 'package:dev_doctor/models/collection.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import 'layout.dart';

class CollectionsSettingsPage extends StatefulWidget {
  @override
  _CollectionsSettingsPageState createState() => _CollectionsSettingsPageState();
}

class _CollectionsSettingsPageState extends State<CollectionsSettingsPage> {
  final _box = Hive.box<String>('collections');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "settings.collections.title".tr()),
      body: SettingsLayout(
          child: ValueListenableBuilder(
              valueListenable: _box.listenable(),
              builder: (context, Box<String> box, _) => FutureBuilder(
                  future: Future.wait(_box.values
                      .toList()
                      .asMap()
                      .map((index, e) =>
                          MapEntry(index, BackendCollection.fetch(url: e, index: index)))
                      .values),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                        var data = snapshot.data as List<BackendCollection>?;
                        return Scrollbar(
                            child: ListView.builder(
                                itemCount: box.length,
                                itemBuilder: (context, index) {
                                  var current = data![index];
                                  return Dismissible(
                                      // Show a red background as the item is swiped away.
                                      background: Container(color: Colors.red),
                                      key: Key(current.url!),
                                      onDismissed: (direction) => _deleteServer(index),
                                      child: ListTile(
                                          leading: current.icon?.isEmpty ?? true
                                              ? null
                                              : UniversalImage(
                                                  type: current.icon, url: current.url! + "/icon"),
                                          title: Text(
                                              current.name ?? 'settings.collections.error'.tr()),
                                          subtitle: Text(current.url!)));
                                }));
                    }
                  }))),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("settings.collections.add.fab").tr(),
        icon: Icon(Icons.add_outlined),
        onPressed: () => _showDialog(),
      ),
    );
  }

  _deleteServer(int index) async {
    await _box.deleteAt(index);
  }

  _createCollection(String url) async {
    var server = await BackendCollection.fetch(url: url);
    if (server.name == null)
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("settings.collections.error").tr(),
                actions: [
                  TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close_outlined),
                      label: Text("close".tr().toUpperCase()))
                ],
              ));
    else
      await _box.add(url);
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
                            labelText: 'settings.collections.add.url'.tr(),
                            hintText: 'settings.collections.add.hint'.tr()),
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
                        _createCollection(url);
                      })
                ]));
  }
}
