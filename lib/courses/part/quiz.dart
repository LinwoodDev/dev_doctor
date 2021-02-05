import 'package:dev_doctor/models/items/quiz.dart';
import 'package:flutter/material.dart';

class QuizPartItemPage extends StatefulWidget {
  final QuizPartItem item;

  const QuizPartItemPage({Key key, this.item}) : super(key: key);

  @override
  _QuizPartItemPageState createState() => _QuizPartItemPageState();
}

class _QuizPartItemPageState extends State<QuizPartItemPage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("QUIZ"));
  }
}
