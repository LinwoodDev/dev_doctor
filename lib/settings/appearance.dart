import 'package:dev_doctor/widgets/appbar.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class AppearanceSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appearanceBox = Hive.box('appearance');
    return Scaffold(
        appBar: MyAppBar(title: 'settings.appearance.title'.tr()),
        body: Container(
            child: ValueListenableBuilder(
                valueListenable: _appearanceBox.listenable(),
                builder: (context, Box<dynamic> box, _) {
                  var theme = ThemeMode.values[_appearanceBox.get('theme', defaultValue: 0)];
                  var locale = _appearanceBox.get('locale', defaultValue: 'default');
                  return ListView(children: [
                    ListTile(
                        title: Text('settings.appearance.locale.title').tr(),
                        subtitle: Text('settings.appearance.locale.$locale'),
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              String selectedLocale = locale;
                              var locales = context.supportedLocales;
                              return AlertDialog(
                                  actions: [
                                    FlatButton(
                                        child: Text('CANCEL'),
                                        onPressed: () => Navigator.of(context).pop()),
                                    FlatButton(
                                        child: Text('SAVE'),
                                        onPressed: () async {
                                          context.locale =
                                              Locale.fromSubtags(scriptCode: selectedLocale);
                                          _appearanceBox.put('locale', selectedLocale);
                                          Navigator.pop(context);
                                        })
                                  ],
                                  content: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      print(locales);
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          RadioListTile<String>(
                                            value: "default",
                                            groupValue: selectedLocale,
                                            title: Text('settings.appearance.locale.default'),
                                            onChanged: (value) {
                                              setState(() => selectedLocale = value);
                                            },
                                          ),
                                          ...List<Widget>.generate(locales.length, (int index) {
                                            return RadioListTile<String>(
                                              value: locales[index]?.scriptCode,
                                              groupValue: selectedLocale,
                                              title: Text('settings.appearance.locale.' +
                                                      locales[index]?.scriptCode)
                                                  .tr(),
                                              onChanged: (value) {
                                                setState(() => selectedLocale = value);
                                              },
                                            );
                                          })
                                        ],
                                      );
                                    },
                                  ));
                            })),
                    ListTile(
                        title: Text('settings.appearance.theme.title').tr(),
                        subtitle:
                            Text('settings.appearance.theme.' + EnumToString.convertToString(theme))
                                .tr(),
                        onTap: () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              ThemeMode selectedRadio = theme;
                              return AlertDialog(
                                actions: [
                                  FlatButton(
                                      child: Text('CANCEL'),
                                      onPressed: () => Navigator.of(context).pop()),
                                  FlatButton(
                                      child: Text('SAVE'),
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
                                          title: Text('settings.appearance.theme.' +
                                                  EnumToString.convertToString(
                                                      ThemeMode.values[index]))
                                              .tr(),
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
