import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  @override
  final Size preferredSize;

  MyAppBar({this.title, Key key})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [IconButton(icon: Icon(Icons.settings_outlined), onPressed: () {})],
      automaticallyImplyLeading: true,
    );
  }
}
