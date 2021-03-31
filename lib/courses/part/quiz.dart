import 'dart:async';

import 'package:dev_doctor/courses/part/bloc.dart';
import 'package:dev_doctor/editor/part.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/item.dart';
import 'package:dev_doctor/models/items/quiz.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class QuizPartItemPage extends StatefulWidget {
  final QuizPartItem item;
  final ServerEditorBloc editorBloc;
  final int itemId;

  const QuizPartItemPage({Key key, this.item, this.editorBloc, this.itemId}) : super(key: key);

  @override
  _QuizPartItemPageState createState() => _QuizPartItemPageState();
}

class _QuizPartItemPageState extends State<QuizPartItemPage> {
  final _formKey = GlobalKey<FormState>();
  int _points = null;
  CoursePartBloc bloc;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.editorBloc != null) {
      bloc = EditorPartModule.to.get<CoursePartBloc>();
      startTimer();
    }
  }

  void validate() {
    _timer?.cancel();
    _points = 0;
    _start = null;
    var validate = _formKey.currentState.validate();
    if (widget.editorBloc != null) {
      _start = widget.item.time;
      _points = null;
    }
    setState(() {});
    if (widget.editorBloc == null)
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
    if (widget.editorBloc == null)
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
        child: _timer != null || widget.item.time == null || widget.editorBloc != null
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
                            if (_start != null || widget.editorBloc != null)
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 32),
                                  child: Row(children: [
                                    Expanded(
                                        child: Column(children: [
                                      Text(
                                        widget.editorBloc == null || _start != null
                                            ? _start.toString() + "/" + widget.item.time.toString()
                                            : "course.quiz.time.notset".tr(),
                                        style: Theme.of(context).textTheme.headline3,
                                      ),
                                      if (_start != null)
                                        Text("course.quiz.time.subtitle",
                                                style: Theme.of(context).textTheme.subtitle2)
                                            .tr()
                                    ])),
                                    if (widget.editorBloc != null) ...[
                                      IconButton(
                                          icon: Icon(Icons.edit_outlined),
                                          onPressed: () => _showTimerDialog()),
                                      if (_start != null)
                                        IconButton(
                                            icon: Icon(Icons.delete_outline_outlined),
                                            onPressed: () async {
                                              updateItem(widget.item.copyWith(time: null));
                                            })
                                    ]
                                  ]))
                          ])),
                  Column(children: [
                    ...List.generate(widget.item.questions.length, (questionIndex) {
                      var question = widget.item.questions[questionIndex];
                      return Column(children: [
                        Row(children: [
                          Expanded(
                              child: Text(
                            question.title,
                            style: Theme.of(context).textTheme.headline6,
                          )),
                          if (widget.editorBloc != null) ...[
                            PopupMenuButton(
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                          value: 'add',
                                          child: Row(children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.verified_outlined),
                                            ),
                                            Column(
                                              children: [],
                                            )
                                          ]))
                                    ]),
                            if (widget.editorBloc != null)
                              PopupMenuButton<QuestionOption>(
                                  itemBuilder: (context) => QuestionOption.values.map((e) {
                                        var description = e.getDescription(question);
                                        return PopupMenuItem<QuestionOption>(
                                            child: Row(children: [
                                          Icon(e.icon),
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(e.name),
                                                if (description != null)
                                                  Text(description,
                                                      style: Theme.of(context).textTheme.caption)
                                              ])
                                        ]));
                                      }).toList())
                          ]
                        ]),
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
                                    return Row(children: [
                                      Expanded(
                                          child: RadioListTile(
                                              groupValue: field.value,
                                              title: Text(answer.name ?? ''),
                                              subtitle: Text(answer.description ?? ''),
                                              value: index,
                                              onChanged: (int value) =>
                                                  _points == null ? field.didChange(value) : {})),
                                      if (widget.editorBloc != null)
                                        PopupMenuButton<AnswerOption>(
                                            itemBuilder: (context) => AnswerOption.values.map((e) {
                                                  var description = e.getDescription(answer);
                                                  return PopupMenuItem<AnswerOption>(
                                                      child: Row(children: [
                                                    Icon(e.getIcon(answer)),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Text(e.name),
                                                          if (description != null)
                                                            Text(description,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .caption)
                                                        ])
                                                  ]));
                                                }).toList())
                                    ]);
                                  }),
                                  field.hasError
                                      ? Text(
                                          field.errorText,
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : Container()
                                ]))
                      ]);
                    }),
                    if (widget.editorBloc != null)
                      OutlinedButton.icon(
                          onPressed: () {
                            updateItem(widget.item.copyWith(
                                questions: List<QuizQuestion>.from(widget.item.questions)
                                  ..add(QuizQuestion(
                                      title: "course.quiz.question.title".tr(),
                                      description: "",
                                      answers: [
                                        QuizAnswer(
                                            correct: true,
                                            description: "",
                                            name: "course.quiz.question.one".tr()),
                                        QuizAnswer(
                                            correct: false,
                                            description: "",
                                            name: "course.quiz.question.two".tr()),
                                        QuizAnswer(
                                            correct: false,
                                            description: "",
                                            name: "course.quiz.question.three".tr()),
                                        QuizAnswer(
                                            correct: false,
                                            description: "",
                                            name: "course.quiz.question.four".tr())
                                      ],
                                      evaluation: "course.quiz.question.evaluation".tr()))));
                          },
                          label: Text("course.quiz.add".tr()),
                          icon: Icon(Icons.add_outlined)),
                  ]),
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

  Future<void> updateItem(QuizPartItem item) async {
    var courseBloc = widget.editorBloc.getCourse(bloc.course);
    var part = courseBloc.getCoursePart(bloc.part);
    var coursePart = part.copyWith(items: List<PartItem>.from(part.items)..[widget.itemId] = item);
    courseBloc.updateCoursePart(coursePart);
    await widget.editorBloc.save();
    bloc.coursePart.add(coursePart);
    setState(() {
      _start = item.time;
    });
  }

  void _showTimerDialog() {
    TextEditingController timeController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            scrollable: true,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("cancel".tr().toUpperCase())),
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    var time = int.tryParse(timeController.text);
                    updateItem(widget.item.copyWith(time: time));
                  },
                  child: Text("change".tr().toUpperCase()))
            ],
            title: Text("course.quiz.timer.title".tr()),
            content: TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "course.quiz.timer.label".tr(),
                    hintText: "course.quiz.timer.hint".tr()))));
  }
}

enum QuestionOption { answer, title, evaluation, delete }

extension QuestionOptionExtension on QuestionOption {
  String get name {
    switch (this) {
      case QuestionOption.answer:
        return "course.quiz.option.question.answer".tr();
      case QuestionOption.title:
        return "course.quiz.option.question.title".tr();
      case QuestionOption.evaluation:
        return "course.quiz.option.question.evaluation".tr();
      case QuestionOption.delete:
        return "course.quiz.option.question.delete".tr();
    }
    return null;
  }

  IconData get icon {
    switch (this) {
      case QuestionOption.answer:
        return Icons.add_outlined;
      case QuestionOption.title:
        return Icons.edit_outlined;
      case QuestionOption.evaluation:
        return Icons.verified_outlined;
      case QuestionOption.delete:
        return Icons.delete_outline_outlined;
    }
    return null;
  }

  String getDescription(QuizQuestion question) {
    switch (this) {
      case QuestionOption.title:
        return question.title;
      case QuestionOption.evaluation:
        return question.evaluation;
      default:
        return null;
    }
  }

  Future<void> onSelected(BuildContext context, ServerEditorBloc bloc, CoursePartBloc partBloc,
      int itemId, int questionId) async {
    var course = bloc.getCourse(partBloc.course);
    var part = course.getCoursePart(partBloc.part);
    var item = part.items[itemId] as QuizPartItem;
    var question = item.questions[questionId];

    switch (this) {
      case QuestionOption.answer:
        question = question.copyWith(
            answers: List<QuizAnswer>.from(question.answers)..add(QuizAnswer(name: "")));
        break;
      case QuestionOption.title:
        break;
      case QuestionOption.evaluation:
        // TODO: Handle this case.
        break;
      case QuestionOption.delete:
        item =
            item.copyWith(questions: List<QuizQuestion>.from(item.questions)..removeAt(questionId));
        break;
    }
    if (this != QuestionOption.delete)
      item = item.copyWith(
          questions: List<QuizQuestion>.from(item.questions)..[questionId] = question);
    part = part.copyWith(items: List<PartItem>.from(part.items)..[itemId] = item);
    course.updateCoursePart(part);
    await bloc.save();
    partBloc.coursePart.add(part);
  }
}

enum AnswerOption { correct, title, delete }

extension AnswerOptionExtension on AnswerOption {
  String get name {
    switch (this) {
      case AnswerOption.correct:
        return "course.quiz.option.answer.correct".tr();
      case AnswerOption.title:
        return "course.quiz.option.answer.title".tr();
      case AnswerOption.delete:
        return "course.quiz.option.answer.delete".tr();
    }
    return null;
  }

  IconData getIcon(QuizAnswer answer) {
    switch (this) {
      case AnswerOption.correct:
        return answer.correct ? Icons.check_outlined : Icons.clear_outlined;
      case AnswerOption.title:
        return Icons.edit_outlined;
      case AnswerOption.delete:
        return Icons.delete_outline_outlined;
    }
    return null;
  }

  String getDescription(QuizAnswer answer) {
    switch (this) {
      case AnswerOption.correct:
        return answer.correct
            ? "course.quiz.option.answer.correct".tr()
            : "course.quiz.option.answer.wrong".tr();
      default:
        return null;
    }
  }

  Future<void> onSelected(BuildContext context, ServerEditorBloc bloc, CoursePartBloc partBloc,
      int itemId, int questionId, int answerId) async {
    var course = bloc.getCourse(partBloc.course);
    var part = course.getCoursePart(partBloc.part);
    var item = part.items[itemId] as QuizPartItem;
    var question = item.questions[questionId];

    switch (this) {
      case AnswerOption.correct:
        // TODO: Handle this case.
        break;
      case AnswerOption.title:
        // TODO: Handle this case.
        break;
      case AnswerOption.delete:
        // TODO: Handle this case.
        break;
    }
    if (this != QuestionOption.delete)
      item = item.copyWith(
          questions: List<QuizQuestion>.from(item.questions)..[questionId] = question);
    part = part.copyWith(items: List<PartItem>.from(part.items)..[itemId] = item);
    course.updateCoursePart(part);
    await bloc.save();
    partBloc.coursePart.add(part);
  }
}
