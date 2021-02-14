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

  Future<List<String>> _buildFuture() async {
    var response = await http
        .get("https://api.github.com/repos/LinwoodCloud/dev_doctor-backends/contents/metadata/");
    List<dynamic> data = json.decode(response.body);
    return Future.wait(data.map((current) => http
        .get(
            "https://raw.githubusercontent.com/LinwoodCloud/dev_doctor-backends/main/${current['path']}")
        .then((value) => utf8.decode(value.bodyBytes))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("backends.title").tr()),
        body: FutureBuilder<List<String>>(
            future: _buildFuture(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Text("Error: ${snapshot.error}");
              var data = snapshot.data;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var current = json.decode(data[index]);
                  return ListTile(
                    title: Text(current['url']),
                    subtitle: Text(current['source']),
                  );
                },
              );
            }));
  }
}
