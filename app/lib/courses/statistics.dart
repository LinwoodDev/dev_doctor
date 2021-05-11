import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
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
                    int points = 0;
                    int maxPoints = 0;
                    for (var i = 0; i < part.items.length; i++) {
                      maxPoints += part.items[i].points;
                      if (part.itemVisited(i)) points += part.getItemPoints(i) ?? 0;
                    }
                    allScore += points.toInt();
                    allMaxScore += maxPoints.toInt();

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
                                      points.toString() +
                                      "/" +
                                      maxPoints.toString()),
                                  LinearProgressIndicator(value: points / maxPoints),
                                ]))));
                  }),
                  Builder(builder: (context) {
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
                                      allScore.toString() +
                                      "/" +
                                      allMaxScore.toString()),
                                  LinearProgressIndicator(value: allScore / allMaxScore),
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
    var progressHud = ProgressHUD.of(buildContext);
    progressHud?.show();
    await Future.delayed(Duration(seconds: 1));
    try {
      var logoImage = await imageFromAssetBundle("images/logo.png");
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
            image = pw.Image(await flutterImageProvider(NetworkImage(url)), height: 150);
        }
      }
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(children: [
              if (image != null) image,
              pw.Spacer(flex: 1),
              pw.SizedBox(height: 50),
              pw.Text("course.certificate.title".tr(),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
              pw.Center(
                  child: pw.SizedBox(
                width: 300,
                child: pw.Divider(
                    color: PdfColor.fromInt(Theme.of(buildContext).primaryColor.value),
                    thickness: 1.5),
              )),
              pw.Text("course.certificate.description".tr(namedArgs: {
                "name": Hive.box("general").get("name") ?? "Unknown",
                "progress": (progress * 100).round().toString(),
                "score": score.toString(),
                "course": course.name,
                "max_score": maxScore.toString()
              })),
              pw.Spacer(flex: 2),
              pw.Row(children: [
                pw.Image(logoImage, height: 50),
                pw.Expanded(
                    child: pw.UrlLink(
                        child: pw.Text("title".tr(), textAlign: pw.TextAlign.center),
                        destination: "https://dev-doctor.cf")),
                pw.UrlLink(
                    child: pw.Text(course.name),
                    destination: Uri(
                            scheme: "https",
                            host: "dev-doctor.cf",
                            fragment: Uri(pathSegments: [
                              "",
                              "courses",
                              "start",
                              "item"
                            ], queryParameters: {
                              "server": course.server?.url,
                              "course": course.slug,
                              "partId": 0.toString()
                            }).toString())
                        .toString())
              ])
            ]);
          }));
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'certificate.pdf');
    } catch (e) {
      print("Error $e");
    }
    progressHud?.dismiss();
  }
}
