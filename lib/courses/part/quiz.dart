import 'dart:async';

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
  int _points = null;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void validate() {
    _timer?.cancel();
    _points = 0;
    _start = null;
    var validate = _formKey.currentState.validate();
    setState(() {});
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("course.quiz.validation.title").tr(),
              content: Text("course.quiz.validation." + (validate ? "correct" : "wrong")).tr(),
              actions: [
                TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_outlined),
                    label: Text("close".tr().toUpperCase()))
              ],
            ));
  }

  Timer _timer = null;
  int _start = null;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _start = widget.item.time;
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() => validate());
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _timer != null || widget.item.time == null
            ? Form(
                key: _formKey,
                child: Column(children: [
                  Builder(
                      builder: (context) => Column(children: [
                            if (_points != null)
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 32),
                                  child: Column(children: [
                                    Text(
                                      _points.toString(),
                                      style: Theme.of(context).textTheme.headline2,
                                    ),
                                    Text("course.quiz.points",
                                            style: Theme.of(context).textTheme.subtitle2)
                                        .tr(),
                                    Padding(
                                        padding: EdgeInsets.all(4),
                                        child: ElevatedButton.icon(
                                            icon: Icon(Icons.replay_outlined),
                                            onPressed: () => setState(() {
                                                  _points = null;
                                                  _formKey.currentState.reset();
                                                  if (widget.item.time != null) startTimer();
                                                }),
                                            label: Text("course.quiz.retry".tr().toUpperCase())))
                                  ]))
                            else
                              Container(),
                            if (_start != null)
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 32),
                                  child: Column(children: [
                                    Text(
                                      _start.toString() + "/" + widget.item.time.toString(),
                                      style: Theme.of(context).textTheme.headline2,
                                    ),
                                    Text("course.quiz.time",
                                            style: Theme.of(context).textTheme.subtitle2)
                                        .tr()
                                  ]))
                          ])),
                  Column(
                      children: List.generate(widget.item.questions.length, (questionIndex) {
                    var question = widget.item.questions[questionIndex];
                    return Column(children: [
                      Text(
                        question.title,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      FormField<int>(
                          validator: (value) {
                            if (value == null) return "course.quiz.choose".tr();
                            if (!question.answers[value].correct)
                              return question.evaluation ?? "course.quiz.wrong".tr();
                            _points += question.answers[value].points ?? 1;
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
                                      onChanged: (int value) =>
                                          _points == null ? field.didChange(value) : {});
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
                  if (_points == null)
                    ElevatedButton.icon(
                        onPressed: () => validate(),
                        icon: Icon(Icons.check_outlined),
                        label: Text("course.quiz.check".tr().toUpperCase()))
                ]))
            : Center(
                child: ElevatedButton.icon(
                    icon: Icon(Icons.check_box_outlined),
                    onPressed: () => setState(() => startTimer()),
                    label: Text("course.quiz.start".tr().toUpperCase()))));
  }
}
