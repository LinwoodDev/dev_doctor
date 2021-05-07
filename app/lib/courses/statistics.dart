import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:flutter/material.dart';

class CourseStatisticsView extends StatelessWidget {
  final Course course;

  const CourseStatisticsView({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<List<CoursePart>>(
            future: course.fetchParts(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Text("Error ${snapshot.error}");
              var parts = snapshot.data!;
              return ListView.builder(
                  itemCount: parts.length,
                  itemBuilder: (context, index) {
                    var part = parts[index];
                    return Padding(
                        padding: EdgeInsets.all(4),
                        child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(children: [
                                  Text(part.name, style: Theme.of(context).textTheme.headline6)
                                ]))));
                  });
            }));
  }
}
