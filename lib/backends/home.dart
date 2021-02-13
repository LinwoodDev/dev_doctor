import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

class BackendsPage extends StatefulWidget {
  @override
  _BackendsPageState createState() => _BackendsPageState();
}

class _BackendsPageState extends State<BackendsPage> {
  void initState() {
    super.initState();

    _buildFuture();
  }

  Future<void> _buildFuture() async {
    var response = await http
        .get("https://api.github.com/repos/LinwoodCloud/dev_doctor-backends/contents/data/");
    var data = json.decode(response.body);
    response = await http.get(
        "https://api.github.com/repos/LinwoodCloud/dev_doctor-backends/contents/${data[0]['path']}/");
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("backends.title").tr()),
        body: FutureBuilder(
            future: _buildFuture(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Text("Error: ${snapshot.error}");
              return ListView(
                children: [Text("TEeST")],
              );
            }));
  }
}
