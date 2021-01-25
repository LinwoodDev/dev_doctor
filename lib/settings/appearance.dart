import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppearanceSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appearanceBox = Hive.box('appearance');
    return Scaffold(
        appBar: MyAppBar(title: "Appearance Settings"),
        body: Container(
            child: ValueListenableBuilder(
                valueListenable: _appearanceBox.listenable(),
                builder: (context, Box<dynamic> box, _) {
                  var theme = ThemeMode.values[_appearanceBox.get('theme', defaultValue: 0)];
                  return ListView(children: [
                    ListTile(
                        title: Text("Theme"),
                        subtitle: Text(theme.toString()),
                        onTap: () => showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              ThemeMode selectedRadio = theme;
                              return AlertDialog(
                                actions: [
                                  FlatButton(
                                      child: Text("CANCEL"),
                                      onPressed: () => Navigator.of(context).pop()),
                                  FlatButton(
                                      child: Text("SAVE"),
                                      onPressed: () async {
                                        _appearanceBox.put('theme', selectedRadio.index);
                                        Navigator.pop(context);
                                      })
                                ],
                                content: StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List<Widget>.generate(ThemeMode.values.length,
                                          (int index) {
                                        return RadioListTile<ThemeMode>(
                                          value: ThemeMode.values[index],
                                          groupValue: selectedRadio,
                                          title: Text(ThemeMode.values[index].toString()),
                                          onChanged: (value) {
                                            setState(() => selectedRadio = value);
                                          },
                                        );
                                      }),
                                    );
                                  },
                                ),
                              );
                            }))
                  ]);
                })));
  }
}
