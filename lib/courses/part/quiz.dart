import 'package:dev_doctor/models/items/quiz.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class QuizPartItemPage extends StatefulWidget {
  final QuizPartItem item;

  const QuizPartItemPage({Key key, this.item}) : super(key: key);

  @override
  _QuizPartItemPageState createState() => _QuizPartItemPageState();
}

class _QuizPartItemPageState extends State<QuizPartItemPage> {
  Map<int, int> answers = {};
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
            child: Scrollbar(
                child: ListView(children: [
      ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.item.questions.length,
          itemBuilder: (context, questionIndex) {
            var question = widget.item.questions[questionIndex];
            return Column(children: [
              Text(question.title),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: question.answers.length,
                itemBuilder: (context, index) {
                  var answer = question.answers[index];
                  return RadioListTile(
                      groupValue: answers[questionIndex] ?? null,
                      title: Text(answer.name ?? ''),
                      subtitle: Text(answer.description ?? ''),
                      value: index,
                      onChanged: (int value) => setState(() => answers[questionIndex] = value));
                },
              )
            ]);
          }),
      ElevatedButton.icon(
          onPressed: () => print("TEST"),
          icon: Icon(Icons.check_outlined),
          label: Text("course.question.check").tr())
    ]))));
  }
}
