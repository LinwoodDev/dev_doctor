import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:window_manager/window_manager.dart';

isWindow() =>
    !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

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
    if (isWindow()) {
      return DragToMoveArea(child: _buildAppBar());
    }
    return _buildAppBar();
  }

  Widget _buildAppBar() => AppBar(
        leading: leading,
        elevation: 5.0,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: isWindow()
            ? DragToMoveArea(child: Text(title ?? ''))
            : Text(title ?? ''),
        bottom: bottom,
        actions: [
          ...actions,
          if (actions.isNotEmpty)
            if (isWindow()) const VerticalDivider(),
          const WindowButtons()
        ],
        //actions: [IconButton(icon: Icon(Icons.settings_outlined), onPressed: () {})],
      );
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && isWindow()) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(PhosphorIcons.minusLight, size: 16),
              onPressed: () => windowManager.minimize(),
            ),
            IconButton(
              icon: const Icon(PhosphorIcons.squareLight, size: 16),
              onPressed: () async => await windowManager.isMaximized()
                  ? windowManager.unmaximize()
                  : windowManager.maximize(),
            ),
            IconButton(
              icon: const Icon(PhosphorIcons.xLight, size: 16),
              onPressed: () => windowManager.close(),
            )
          ],
        ),
      );
    }
    return Container();
  }
}

class ConditionalMoveWindow extends StatelessWidget {
  final Widget child;

  const ConditionalMoveWindow({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) if (isWindow()) return DragToMoveArea(child: child);
    return child;
  }
}
