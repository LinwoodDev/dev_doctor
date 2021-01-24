import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';

import 'app_widget.dart';
import 'models/server.dart';

class AddServerPage extends StatefulWidget {
  final Map<String, String> params;

  const AddServerPage({Key key, this.params}) : super(key: key);
  @override
  _AddServerPageState createState() => _AddServerPageState();
}

class _AddServerPageState extends State<AddServerPage> {
  @override
  void initState() {
    super.initState();
    print(widget.params);
    Future.delayed(Duration.zero, () => _showDialog());
  }

  _showDialog() async {
    var url = widget.params['url'];
    var server = await CoursesServer.fetch(url);
    var shouldAdd = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                actions: [
                  FlatButton(child: Text("NO"), onPressed: () => Navigator.of(context).pop(false)),
                  FlatButton(child: Text("YES"), onPressed: () => Navigator.of(context).pop(true))
                ],
                title: Text("Do you want to add the server ${server.name}?"),
                content: Text(
                    "The server ${server.name} with the url ${server.url} will displayed on the courses page.")));
    if (shouldAdd) {
      await Hive.box<String>('servers').add(url);
      print("ADDED!");
    }
    Modular.to.navigate('/');
  }

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}
