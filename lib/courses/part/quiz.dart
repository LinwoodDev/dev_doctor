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
  final _formKey = GlobalKey<FormState>();
  void validate() {
    var validate = _formKey.currentState.validate();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("course.question.validation.title").tr(),
              content: Text("course.question.validation." + (validate ? "correct" : "wrong")).tr(),
              actions: [
                TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_outlined),
                    label: Text("course.question.validation.close").tr())
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
            key: _formKey,
            child: Scrollbar(
                child: ListView(children: [
              Column(
                  children: List.generate(widget.item.questions.length, (questionIndex) {
                var question = widget.item.questions[questionIndex];
                return Column(children: [
                  Text(question.title),
                  FormField<int>(
                      validator: (value) {
                        if (value == null) return "course.question.choose".tr();
                        if (!question.answers[value].correct) return "course.question.wrong".tr();
                        return null;
                      },
                      builder: (field) => Column(children: [
                            ...List.generate(question.answers.length, (index) {
                              var answer = question.answers[index];
                              return RadioListTile(
                                  groupValue: field.value,
                                  title: Text(answer.name ?? ''),
                                  subtitle: Text(answer.description ?? ''),
                                  value: index,
                                  onChanged: (int value) => field.didChange(value));
                            }),
                            field.hasError
                                ? Text(
                                    field.errorText,
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Container()
                          ]))
                ]);
              })),
              ElevatedButton.icon(
                  onPressed: validate,
                  icon: Icon(Icons.check_outlined),
                  label: Text("course.question.check").tr())
            ]))));
  }
}
