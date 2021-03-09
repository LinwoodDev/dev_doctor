import 'package:dev_doctor/editor/bloc/server.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';

class PartDetailsPage extends StatefulWidget {
  final CoursePart model;
  final int partId;
  final int courseId;
  final int serverId;
  final ServerEditorBloc editorBloc;

  const PartDetailsPage(
      {Key key, this.model, this.partId, this.courseId, this.serverId, this.editorBloc})
      : super(key: key);
  @override
  _PartDetailsPageState createState() => _PartDetailsPageState();
}

class _PartDetailsPageState extends State<PartDetailsPage> {
  Future<CoursePart> _buildFuture() async {
    if (widget.model != null) return widget.model;
    var server = await CoursesServer.fetch(index: widget.serverId);
    var course = await server.fetchCourse(widget.courseId);
    return course.fetchPart(widget.partId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CoursePart>(
        future: _buildFuture(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Text("Error ${snapshot.error}");
          var part = snapshot.data;
          return Scaffold(appBar: MyAppBar(title: part.name), body: ListView(children: []));
        });
  }
}
