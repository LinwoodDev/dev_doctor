import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';

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
              var allScore = 0;
              var allMaxScore = 0;
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
                    allScore += points.toInt();
                    allMaxScore += maxPoints.toInt();
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
                                  Text("course.progress".tr() +
                                      " " +
                                      (progress * 100).round().toString() +
                                      "%"),
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
                                  Text("course.points".tr() +
                                      " " +
                                      (points * 100).round().toString() +
                                      "%"),
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
                                  Text("course.progress".tr() +
                                      " " +
                                      (allProgress * 100).round().toString() +
                                      "%"),
                                  LinearProgressIndicator(value: allProgress),
                                  SizedBox(height: 50),
                                  Text("course.points".tr() +
                                      " " +
                                      (allPoints * 100).round().toString() +
                                      "%"),
                                  LinearProgressIndicator(value: allPoints),
                                  SizedBox(height: 50),
                                  ElevatedButton.icon(
                                      onPressed: () => _downloadCertificate(
                                          context, allProgress, allScore, allMaxScore),
                                      icon: Icon(Icons.download_outlined),
                                      label: Text("course.certificate.button".tr().toUpperCase()))
                                ]))));
                  })
                ]),
              );
            }));
  }

  Future<void> _downloadCertificate(
      BuildContext buildContext, double progress, int score, int maxScore) async {
    var progress = ProgressHUD.of(buildContext);
    progress?.show();
    final pdf = pw.Document();
    pw.Widget? image = null;
    if (course.icon != null) {
      var url = course.url + "/icon." + course.icon;
      switch (course.icon) {
        case "svg":
          var response = await http.get(Uri.parse(url));
          image = pw.SvgImage(svg: response.body);
          break;
        case "png":
        case "jpg":
        case "jpeg":
          var sunImage = new NetworkImage(url);
          image = pw.Image(await flutterImageProvider(sunImage), height: 150);
      }
    }
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Center(
            child: pw.Column(children: [
          pw.Spacer(flex: 1),
          if (image != null) image,
          pw.SizedBox(height: 50),
          pw.Text("course.certificate.title".tr(),
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
          pw.SizedBox(
            width: 300,
            child: pw.Divider(
                color: PdfColor.fromInt(Theme.of(buildContext).primaryColor.value), thickness: 1.5),
          ),
          pw.Text("course.certificate.description".tr(namedArgs: {
            "name": Hive.box("general").get("name") ?? "Unknown",
            "progress": (progress * 100).round().toString(),
            "score": score.toString(),
            "max_score": maxScore.toString()
          })),
          pw.Spacer(flex: 2),
        ]));
      },
    ));
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'certificate.pdf');
    progress?.dismiss();
  }
}
