import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const borderColor = Color(0xFF805306);

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  @override
  final Size preferredSize;
  final List<Widget> actions;

  final PreferredSizeWidget bottom;

  MyAppBar({this.title, this.actions = const [], Key key, this.bottom, double height})
      : preferredSize = Size.fromHeight(height ?? 50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
      return WindowBorder(color: borderColor, width: 1, child: _buildAppBar());
    return _buildAppBar();
  }

  Widget _buildAppBar() => MoveWindow(
          child: AppBar(
        elevation: 5.0,
        title: WindowTitleBarBox(child: Text(title)),
        bottom: bottom,
        actions: [...actions, if (actions.isNotEmpty) VerticalDivider(), WindowButtons()],
        //actions: [IconButton(icon: Icon(Icons.settings_outlined), onPressed: () {})],
        automaticallyImplyLeading: true,
      ));
}

const buttonColors = WindowButtonColors(
    iconNormal: Color(0xFF805306),
    mouseOver: Color(0xFFF6A00C),
    mouseDown: Color(0xFF805306),
    iconMouseOver: Color(0xFF805306),
    iconMouseDown: Color(0xFFFFD500));

const closeButtonColors = WindowButtonColors(
    mouseOver: Color(0xFFD32F2F),
    mouseDown: Color(0xFFB71C1C),
    iconNormal: Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.minimize_outlined, size: 16),
              onPressed: () => appWindow.minimize(),
            ),
            IconButton(
              icon: Icon(Icons.check_box_outline_blank_outlined, size: 16),
              onPressed: () => appWindow.maximizeOrRestore(),
            ),
            IconButton(
              icon: Icon(Icons.close_outlined, size: 16),
              onPressed: () => appWindow.close(),
            )
          ],
        ),
      );
    return Container();
  }
}
