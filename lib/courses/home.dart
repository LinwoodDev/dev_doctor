import 'package:dev_doctor/course/home.dart';
import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/server.dart';
import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:easy_localization/easy_localization.dart';

class CoursesPage extends StatefulWidget {
  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final Box<String> _serversBox = Hive.box<String>('servers');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: 'courses.title'.tr(), actions: [
          IconButton(icon: Icon(Icons.search_outlined), onPressed: () {}),
          IconButton(icon: Icon(Icons.filter_list_outlined), onPressed: () {})
        ]),
        body: FutureBuilder(
          future: _buildFuture(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                var data = snapshot.data as List<Course>;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var current = data[index];
                    return ListTile(
                      title: Text(current.name),
                      subtitle: Text(current.description),
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => CoursePage())),
                      leading: current.icon?.isEmpty ?? true
                          ? null
                          : UniversalImage(type: current.icon, url: current.url + "/icon"),
                      isThreeLine: true,
                    );
                  },
                );
            }
          },
        ));
  }

  Future<List<Course>> _buildFuture() async {
    var servers = await Future.wait(_serversBox.values.map((e) => CoursesServer.fetch(e)));
    List<Course> courses = [];
    await Future.wait(servers.map((e) async => courses.addAll(await e.fetchCourses())));
    return courses;
  }
}