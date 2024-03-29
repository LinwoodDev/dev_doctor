import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).canvasColor,
        child: Column(children: [
          Text("error".tr(), style: Theme.of(context).textTheme.headline1),
          if (Modular.to.canPop())
            TextButton(
                onPressed: () => Modular.to.pop(),
                child: const Text("back").tr()),
          TextButton(
              onPressed: () => Modular.to.navigate("/"),
              child: Text("back-to-home".tr()))
        ]));
  }
}
