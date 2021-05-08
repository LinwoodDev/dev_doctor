import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:easy_localization/easy_localization.dart';

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
              double allPoints = 0;
              double allProgress = 0;
              return SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  ...List.generate(parts.length, (index) {
                    var part = parts[index];
                    double progress = 0;
                    for (var i = 0; i < part.items.length; i++)
                      if (part.itemVisited(i)) progress += 1;
                    progress /= part.items.length;
                    allProgress += progress;
                    double points = 0;
                    double maxPoints = 0;
                    for (var i = 0; i < part.items.length; i++) {
                      maxPoints += part.items[i].points;
                      if (part.itemVisited(i)) points += (part.getItemPoints(i)?.toDouble() ?? 0);
                    }
                    points /= part.items.length;
                    points /= maxPoints;

                    allPoints += points;
                    return Padding(
                        padding: EdgeInsets.all(4),
                        child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                                child: Column(children: [
                                  Text(part.name, style: Theme.of(context).textTheme.headline6),
                                  SizedBox(height: 50),
                                  Text((progress * 100).round().toString() + "%"),
                                  LinearProgressIndicator(value: progress),
                                  SizedBox(height: 50),
                                  Wrap(
                                      children: List.generate(part.items.length, (index) {
                                    var item = part.items[index];
                                    return IconButton(
                                        tooltip: "${item.name}" +
                                            (part.itemVisited(index)
                                                ? " ${part.getItemPoints(index)}/${item.points}"
                                                : " 0/${item.points}"),
                                        icon: Icon(item.icon,
                                            color: part.itemVisited(index)
                                                ? Theme.of(context).primaryColor
                                                : null),
                                        onPressed: () => Modular.to.pushNamed(Uri(pathSegments: [
                                              "",
                                              "courses",
                                              "start",
                                              "item"
                                            ], queryParameters: {
                                              "serverId": course.server?.index?.toString(),
                                              "course": course.slug,
                                              "part": part.slug,
                                              "itemId": index.toString()
                                            }).toString()));
                                  })),
                                  SizedBox(height: 50),
                                  Text((points * 100).round().toString() + "%"),
                                  LinearProgressIndicator(value: points),
                                ]))));
                  }),
                  Builder(builder: (context) {
                    allPoints /= parts.length;
                    allProgress /= parts.length;
                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 64),
                        child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                                child: Column(children: [
                                  Text((allProgress * 100).round().toString() + "%"),
                                  LinearProgressIndicator(value: allProgress),
                                  SizedBox(height: 50),
                                  Text((allPoints * 100).round().toString() + "%"),
                                  LinearProgressIndicator(value: allPoints),
                                  SizedBox(height: 50),
                                  ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.download_outlined),
                                      label: Text("course.certificate.title".tr().toUpperCase()))
                                ]))));
                  })
                ]),
              );
            }));
  }
}
