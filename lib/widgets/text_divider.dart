import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  final String? text;

  const TextDivider({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child:
              Container(margin: const EdgeInsets.only(left: 10.0, right: 20.0), child: Divider())),
      Text(
        text!,
        style: Theme.of(context).textTheme.overline,
      ),
      Expanded(
          child:
              Container(margin: const EdgeInsets.only(left: 10.0, right: 20.0), child: Divider())),
    ]);
  }
}
