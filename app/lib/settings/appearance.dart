import 'package:dev_doctor/settings/layout.dart';
import 'package:dev_doctor/themes/theme.dart';
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
        body: SettingsLayout(
            child: ValueListenableBuilder(
                valueListenable: _appearanceBox.listenable(),
                builder: (context, Box<dynamic> box, _) {
                  var theme = ThemeMode.values[_appearanceBox.get('theme', defaultValue: 0)];
                  var locale = context.locale.toLanguageTag();
                  var color = ColorTheme.values[_appearanceBox.get('color', defaultValue: 0)];
                  return Scrollbar(
                      child: ListView(children: [
                    ListTile(
                        title: Text('settings.appearance.locale.title').tr(),
                        subtitle: Text('settings.appearance.locale.$locale').tr(),
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              String? selectedLocale = locale;
                              var locales = context.supportedLocales;
                              return AlertDialog(
                                  actions: [
                                    TextButton(
                                        child: Text('cancel'.tr().toUpperCase()),
                                        onPressed: () => Navigator.of(context).pop()),
                                    TextButton(
                                        child: Text('save'.tr().toUpperCase()),
                                        onPressed: () async {
                                          if (selectedLocale == 'default') {
                                            context.resetLocale();
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text('settings.appearance.locale.restart')
                                                    .tr()));
                                          } else
                                            context.setLocale(Locale(selectedLocale!));
                                          Navigator.pop(context);
                                        })
                                  ],
                                  content: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RadioListTile<String>(
                                              value: "default",
                                              groupValue: selectedLocale,
                                              title:
                                                  Text('settings.appearance.locale.default').tr(),
                                              onChanged: (value) {
                                                setState(() => selectedLocale = value);
                                              },
                                            ),
                                            ...List<Widget>.generate(locales.length, (int index) {
                                              return RadioListTile<String>(
                                                value: locales[index].toLanguageTag(),
                                                groupValue: selectedLocale,
                                                title: Text('settings.appearance.locale.' +
                                                        locales[index].toLanguageTag())
                                                    .tr(),
                                                onChanged: (value) {
                                                  setState(() => selectedLocale = value);
                                                },
                                              );
                                            })
                                          ],
                                        ),
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
                              ThemeMode? selectedRadio = theme;
                              return AlertDialog(
                                actions: [
                                  TextButton(
                                      child: Text('cancel'.tr().toUpperCase()),
                                      onPressed: () => Navigator.of(context).pop()),
                                  TextButton(
                                      child: Text('save'.tr().toUpperCase()),
                                      onPressed: () async {
                                        _appearanceBox.put('theme', selectedRadio!.index);
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
                            })),
                    ListTile(
                      title: Text("settings.appearance.color.title").tr(),
                      subtitle:
                          Text("settings.appearance.color." + EnumToString.convertToString(color))
                              .tr(),
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            ColorTheme? selectedRadio = color;
                            return AlertDialog(
                              actions: [
                                TextButton(
                                    child: Text('cancel'.tr().toUpperCase()),
                                    onPressed: () => Navigator.of(context).pop()),
                                TextButton(
                                    child: Text('save'.tr().toUpperCase()),
                                    onPressed: () async {
                                      _appearanceBox.put('color', selectedRadio!.index);
                                      Navigator.pop(context);
                                    })
                              ],
                              content: StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List<Widget>.generate(ColorTheme.values.length,
                                          (int index) {
                                        return RadioListTile<ColorTheme>(
                                          value: ColorTheme.values[index],
                                          groupValue: selectedRadio,
                                          title: Text('settings.appearance.color.' +
                                                  EnumToString.convertToString(
                                                      ColorTheme.values[index]))
                                              .tr(),
                                          onChanged: (value) {
                                            setState(() => selectedRadio = value);
                                          },
                                        );
                                      }),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                    )
                  ]));
                })));
  }
}
