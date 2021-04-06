import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ErrorDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: SingleChildScrollView(
                child: Center(
                    child: Column(children: [
      Text("error".tr(), style: Theme.of(context).textTheme.headline1),
      if (Modular.to.canPop())
        TextButton(onPressed: () => Modular.to.pop(), child: Text("back").tr()),
      TextButton(onPressed: () => Modular.to.navigate("/"), child: Text("back-home".tr()))
    ])))));
  }
}
