import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const borderColor = Color(0xFF805306);
isWindow() => !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  @override
  final Size preferredSize;
  final List<Widget> actions;

  final PreferredSizeWidget? bottom;

  final Widget? leading;
  final bool automaticallyImplyLeading;

  MyAppBar(
      {this.title,
      this.automaticallyImplyLeading = true,
      this.leading,
      this.actions = const [],
      Key? key,
      this.bottom,
      double? height})
      : preferredSize = Size.fromHeight(height ?? 50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isWindow())
      return MoveWindow(child: WindowBorder(color: borderColor, width: 1, child: _buildAppBar()));
    return _buildAppBar();
  }

  Widget _buildAppBar() => AppBar(
        leading: this.leading,
        elevation: 5.0,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: isWindow() ? WindowTitleBarBox(child: Text(title!)) : Text(title!),
        bottom: bottom,
        actions: [
          ...actions,
          if (actions.isNotEmpty)
            if (isWindow()) VerticalDivider(),
          WindowButtons()
        ],
        //actions: [IconButton(icon: Icon(Icons.settings_outlined), onPressed: () {})],
      );
}

final buttonColors = WindowButtonColors(
    iconNormal: Color(0xFF805306),
    mouseOver: Color(0xFFF6A00C),
    mouseDown: Color(0xFF805306),
    iconMouseOver: Color(0xFF805306),
    iconMouseDown: Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: Color(0xFFD32F2F),
    mouseDown: Color(0xFFB71C1C),
    iconNormal: Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) if (isWindow())
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

class ConditionalMoveWindow extends StatelessWidget {
  final Widget? child;

  const ConditionalMoveWindow({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) if (isWindow()) return MoveWindow(child: child);
    return child!;
  }
}
