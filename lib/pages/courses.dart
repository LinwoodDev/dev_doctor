import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: MyAppBar(title: 'Courses'), body: Container());
  }
}
