import 'package:dev_doctor/settings/home.dart';
import 'package:flutter/material.dart';

class SettingsLayout extends StatefulWidget {
  final Widget child;

  const SettingsLayout({Key key, this.child}) : super(key: key);

  @override
  _SettingsLayoutState createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var mobile = MediaQuery.of(context).size.width < 1100;
      return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          textDirection: TextDirection.rtl,
          children: [
            Expanded(flex: 3, child: widget.child),
            if (!mobile)
              Expanded(
                  child: Container(color: Theme.of(context).canvasColor, child: SettingsList())),
          ]);
    });
  }
}
