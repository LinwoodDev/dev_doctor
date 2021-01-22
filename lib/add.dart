import 'package:flutter/material.dart';

import 'app_widget.dart';
import 'models/server.dart';

class AddServerPage extends StatefulWidget {
  final String url;

  const AddServerPage({Key key, this.url}) : super(key: key);
  @override
  _AddServerPageState createState() => _AddServerPageState();
}

class _AddServerPageState extends State<AddServerPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () => _showDialog());
  }

  _showDialog() async {
    print(widget.url);
    var server = await CoursesServer.fetch(widget.url);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("Do you want to add the server ${server.name}?"),
            content: Text(
                "The server ${server.name} with the url ${server.url} will displayed on the courses page.")));
  }

  @override
  Widget build(BuildContext context) {
    return MyHomePage(index: 0);
  }
}
