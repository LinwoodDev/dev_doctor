import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import 'layout.dart';

class GeneralSettingsPage extends StatelessWidget {
  final Box _generalBox = Hive.box("general");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: 'settings.appearance.title'.tr()),
        body: SettingsLayout(
            child: ValueListenableBuilder(
                valueListenable: _generalBox.listenable(),
                builder: (context, Box<dynamic> box, _) {
                  var name = _generalBox.get('name', defaultValue: 'Unknown');
                  return Scrollbar(
                      child: ListView(children: [
                    ListTile(
                        title: Text('settings.general.name.title').tr(),
                        subtitle: Text(name),
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              var nameController = TextEditingController();
                              return AlertDialog(
                                  scrollable: true,
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("cancel".tr().toUpperCase())),
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          _generalBox.put("name", nameController.text);
                                        },
                                        child: Text("change".tr().toUpperCase()))
                                  ],
                                  title: Text("settings.general.name.title".tr()),
                                  content: TextField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                          labelText: "settings.general.name.label".tr())));
                            })),
                  ]));
                })));
  }
}
