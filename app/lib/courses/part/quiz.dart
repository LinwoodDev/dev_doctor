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
  final ServerEditorBloc? editorBloc;
  final int? itemId;

  const QuizPartItemPage({Key? key, required this.item, this.editorBloc, this.itemId})
      : super(key: key);

  @override
  _QuizPartItemPageState createState() => _QuizPartItemPageState();
}

class _QuizPartItemPageState extends State<QuizPartItemPage> {
  final _formKey = GlobalKey<FormState>();
  int? _points = null;
  late CoursePartBloc bloc;

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
    var validate = _formKey.currentState!.validate();
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

  Timer? _timer = null;
  int? _start = null;

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
              _start = _start! - 1;
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
                                                  _formKey.currentState!.reset();
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
                                          tooltip: "edit".tr(),
                                          icon: Icon(Icons.edit_outlined),
                                          onPressed: () => _showTimerDialog()),
                                      if (_start != null)
                                        IconButton(
                                            tooltip: "delete".tr(),
                                            icon: Icon(Icons.delete_outline_outlined),
                                            onPressed: () async {
                                              updateItem(
                                                  widget.item.copyWith(time: null, timer: false));
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
                              child: Column(children: [
                            Text(
                              question.title!,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(question.description!)
                          ])),
                          if (widget.editorBloc != null)
                            PopupMenuButton<QuestionOption>(
                                onSelected: (value) => value.onSelected(context, widget.editorBloc!,
                                    bloc, widget.itemId!, questionIndex),
                                itemBuilder: (context) => QuestionOption.values.map((e) {
                                      var description = e.getDescription(question);
                                      return PopupMenuItem<QuestionOption>(
                                          value: e,
                                          child: Row(children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(e.icon),
                                            ),
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(e.name!),
                                                  if (description != null)
                                                    Text(description,
                                                        style: Theme.of(context).textTheme.caption)
                                                ])
                                          ]));
                                    }).toList())
                        ]),
                        FormField<int>(
                            validator: (value) {
                              if (value == null) return "course.quiz.choose".tr();
                              if (!question.answers![value].correct)
                                return question.evaluation ?? "course.quiz.wrong".tr();
                              _points = _points! + question.answers![value].points;
                              return null;
                            },
                            builder: (field) => Column(children: [
                                  ...List.generate(question.answers!.length, (index) {
                                    var answer = question.answers![index];
                                    return Row(children: [
                                      Expanded(
                                          child: RadioListTile(
                                              groupValue: field.value,
                                              title: Text(answer.name ?? ''),
                                              subtitle: Text(answer.description ?? ''),
                                              value: index,
                                              onChanged: (int? value) =>
                                                  _points == null ? field.didChange(value) : {})),
                                      if (widget.editorBloc != null)
                                        PopupMenuButton<AnswerOption>(
                                            onSelected: (value) => value.onSelected(
                                                context,
                                                widget.editorBloc!,
                                                bloc,
                                                widget.itemId!,
                                                questionIndex,
                                                index),
                                            itemBuilder: (context) => AnswerOption.values.map((e) {
                                                  var description = e.getDescription(answer);
                                                  return PopupMenuItem<AnswerOption>(
                                                      value: e,
                                                      child: Row(children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Icon(e.getIcon(answer)),
                                                        ),
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Text(e.name!),
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
                                          field.errorText!,
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : Container()
                                ]))
                      ]);
                    }),
                    if (widget.editorBloc != null) ...[
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
                      SizedBox(height: 20)
                    ]
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
    var courseBloc = widget.editorBloc!.getCourse(bloc.course!);
    var part = courseBloc.getCoursePart(bloc.part!);
    var coursePart = part.copyWith(items: List<PartItem>.from(part.items)..[widget.itemId!] = item);
    courseBloc.updateCoursePart(coursePart);
    await widget.editorBloc!.save();
    bloc.partSubject.add(coursePart);
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
            title: Text("course.quiz.time.title".tr()),
            content: TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "course.quiz.time.label".tr(),
                    hintText: "course.quiz.time.hint".tr()))));
  }
}

enum QuestionOption { answer, title, description, evaluation, delete }

extension QuestionOptionExtension on QuestionOption {
  String? get name {
    switch (this) {
      case QuestionOption.answer:
        return "course.quiz.option.question.answer.item".tr();
      case QuestionOption.title:
        return "course.quiz.option.question.title.item".tr();
      case QuestionOption.evaluation:
        return "course.quiz.option.question.evaluation.item".tr();
      case QuestionOption.delete:
        return "course.quiz.option.question.delete.item".tr();
      case QuestionOption.description:
        return "course.quiz.option.question.description.item".tr();
    }
  }

  IconData? get icon {
    switch (this) {
      case QuestionOption.answer:
        return Icons.add_outlined;
      case QuestionOption.title:
        return Icons.edit_outlined;
      case QuestionOption.evaluation:
        return Icons.verified_outlined;
      case QuestionOption.delete:
        return Icons.delete_outline_outlined;
      case QuestionOption.description:
        return Icons.subject_outlined;
    }
  }

  String? getDescription(QuizQuestion question) {
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
    var courseBloc = bloc.getCourse(partBloc.course!);
    var part = courseBloc.getCoursePart(partBloc.part!);
    var item = part.items[itemId] as QuizPartItem;
    var question = item.questions[questionId];
    switch (this) {
      case QuestionOption.answer:
        updateItem(
            bloc,
            partBloc,
            itemId,
            item.copyWith(
                questions: List<QuizQuestion>.from(item.questions)
                  ..[questionId] = question.copyWith(
                      answers: List<QuizAnswer>.from(question.answers!)..add(QuizAnswer()))));
        break;
      case QuestionOption.title:
        TextEditingController titleController = TextEditingController(text: question.title);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    contentPadding: const EdgeInsets.all(16.0),
                    content: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: 'course.quiz.option.question.title.label'.tr(),
                                hintText: 'course.quiz.option.question.title.hint'.tr()),
                          ),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                          child: Text('cancel'.tr().toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      TextButton(
                          child: Text('change'.tr().toUpperCase()),
                          onPressed: () async {
                            Navigator.pop(context);
                            updateItem(
                                bloc,
                                partBloc,
                                itemId,
                                item.copyWith(
                                    questions: List<QuizQuestion>.from(item.questions)
                                      ..[questionId] =
                                          question.copyWith(title: titleController.text)));
                          })
                    ]));
        break;
      case QuestionOption.evaluation:
        TextEditingController evaluationController =
            TextEditingController(text: question.evaluation);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    contentPadding: const EdgeInsets.all(16.0),
                    content: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: evaluationController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: 'course.quiz.option.question.evaluation.label'.tr(),
                                hintText: 'course.quiz.option.question.evaluation.hint'.tr()),
                          ),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                          child: Text('cancel'.tr().toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      TextButton(
                          child: Text('change'.tr().toUpperCase()),
                          onPressed: () async {
                            Navigator.pop(context);
                            updateItem(
                                bloc,
                                partBloc,
                                itemId,
                                item.copyWith(
                                    questions: List<QuizQuestion>.from(item.questions)
                                      ..[questionId] = question.copyWith(
                                          evaluation: evaluationController.text)));
                          })
                    ]));
        break;
      case QuestionOption.delete:
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    actions: [
                      TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close_outlined),
                          label: Text("no".tr().toUpperCase())),
                      TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            updateItem(
                                bloc,
                                partBloc,
                                itemId,
                                item.copyWith(
                                    questions: List<QuizQuestion>.from(item.questions)
                                      ..removeAt(questionId)));
                          },
                          icon: Icon(Icons.check_outlined),
                          label: Text("yes".tr().toUpperCase()))
                    ],
                    title: Text("course.quiz.option.question.delete.title").tr(),
                    content: Text("course.quiz.option.question.delete.content")
                        .tr(namedArgs: {"index": questionId.toString(), "name": question.title!})));
        break;
      case QuestionOption.description:
        TextEditingController descriptionController =
            TextEditingController(text: question.description);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    contentPadding: const EdgeInsets.all(16.0),
                    content: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: descriptionController,
                            minLines: 3,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                labelText: 'course.quiz.option.question.description.label'.tr(),
                                hintText: 'course.quiz.option.question.description.hint'.tr()),
                          ),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                          child: Text('cancel'.tr().toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      TextButton(
                          child: Text('change'.tr().toUpperCase()),
                          onPressed: () async {
                            Navigator.pop(context);
                            updateItem(
                                bloc,
                                partBloc,
                                itemId,
                                item.copyWith(
                                    questions: List<QuizQuestion>.from(item.questions)
                                      ..[questionId] = question.copyWith(
                                          description: descriptionController.text)));
                          })
                    ]));
        break;
    }
  }

  Future<void> updateItem(
      ServerEditorBloc bloc, CoursePartBloc partBloc, int itemId, QuizPartItem item) async {
    var courseBloc = bloc.getCourse(partBloc.course!);
    var part = courseBloc.getCoursePart(partBloc.part!);
    var coursePart = part.copyWith(items: List<PartItem>.from(part.items)..[itemId] = item);
    courseBloc.updateCoursePart(coursePart);
    await bloc.save();
    partBloc.partSubject.add(coursePart);
  }
}

enum AnswerOption { rating, title, description, points, delete }

extension AnswerOptionExtension on AnswerOption {
  String? get name {
    switch (this) {
      case AnswerOption.rating:
        return "course.quiz.option.answer.rating".tr();
      case AnswerOption.title:
        return "course.quiz.option.answer.title.item".tr();
      case AnswerOption.description:
        return "course.quiz.option.answer.description.item".tr();
      case AnswerOption.delete:
        return "course.quiz.option.answer.delete.item".tr();
      case AnswerOption.points:
        return "course.quiz.option.answer.points.item".tr();
    }
  }

  IconData? getIcon(QuizAnswer answer) {
    switch (this) {
      case AnswerOption.rating:
        return answer.correct ? Icons.check_outlined : Icons.clear_outlined;
      case AnswerOption.title:
        return Icons.edit_outlined;
      case AnswerOption.delete:
        return Icons.delete_outline_outlined;
      case AnswerOption.description:
        return Icons.subject_outlined;
      case AnswerOption.points:
        return Icons.attach_money_outlined;
    }
  }

  String? getDescription(QuizAnswer answer) {
    switch (this) {
      case AnswerOption.rating:
        return answer.correct
            ? "course.quiz.option.answer.correct".tr()
            : "course.quiz.option.answer.wrong".tr();
      case AnswerOption.title:
        return answer.name;
      case AnswerOption.description:
        return answer.description;
      case AnswerOption.points:
        return answer.points.toString();
      default:
        return null;
    }
  }

  Future<void> onSelected(BuildContext context, ServerEditorBloc bloc, CoursePartBloc partBloc,
      int itemId, int questionId, int answerId) async {
    var course = bloc.getCourse(partBloc.course!);
    var part = course.getCoursePart(partBloc.part!);
    var item = part.items[itemId] as QuizPartItem;
    var question = item.questions[questionId];
    var answer = question.answers![answerId];

    switch (this) {
      case AnswerOption.rating:
        updateQuestion(
            bloc,
            partBloc,
            itemId,
            questionId,
            question.copyWith(
                answers: List<QuizAnswer>.from(question.answers!)
                  ..[answerId] = answer.copyWith(correct: !answer.correct)));
        break;
      case AnswerOption.title:
        TextEditingController titleController = TextEditingController(text: answer.name);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    contentPadding: const EdgeInsets.all(16.0),
                    content: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: 'course.quiz.option.answer.title.label'.tr(),
                                hintText: 'course.quiz.option.answer.title.hint'.tr()),
                          ),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                          child: Text('cancel'.tr().toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      TextButton(
                          child: Text('change'.tr().toUpperCase()),
                          onPressed: () async {
                            Navigator.pop(context);
                            updateQuestion(
                                bloc,
                                partBloc,
                                itemId,
                                questionId,
                                question.copyWith(
                                    answers: List<QuizAnswer>.from(question.answers!)
                                      ..[answerId] = answer.copyWith(name: titleController.text)));
                          })
                    ]));
        break;
      case AnswerOption.delete:
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    actions: [
                      TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close_outlined),
                          label: Text("no".tr().toUpperCase())),
                      TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            updateQuestion(
                                bloc,
                                partBloc,
                                itemId,
                                questionId,
                                question.copyWith(
                                    answers: List<QuizAnswer>.from(question.answers!)
                                      ..removeAt(answerId)));
                          },
                          icon: Icon(Icons.check_outlined),
                          label: Text("yes".tr().toUpperCase()))
                    ],
                    title: Text("course.quiz.option.answer.delete.title").tr(),
                    content: Text("course.quiz.option.answer.delete.content")
                        .tr(namedArgs: {"index": answerId.toString(), "name": answer.name!})));
        break;
      case AnswerOption.description:
        TextEditingController descriptionController =
            TextEditingController(text: answer.description);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    contentPadding: const EdgeInsets.all(16.0),
                    content: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: descriptionController,
                            minLines: 3,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                labelText: 'course.quiz.option.answer.description.label'.tr(),
                                hintText: 'course.quiz.option.answer.description.hint'.tr()),
                          ),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                          child: Text('cancel'.tr().toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      TextButton(
                          child: Text('change'.tr().toUpperCase()),
                          onPressed: () async {
                            Navigator.pop(context);
                            updateQuestion(
                                bloc,
                                partBloc,
                                itemId,
                                questionId,
                                question.copyWith(
                                    answers: List<QuizAnswer>.from(question.answers!)
                                      ..[answerId] = answer.copyWith(
                                          description: descriptionController.text)));
                          })
                    ]));
        break;
      case AnswerOption.points:
        TextEditingController pointsController =
            TextEditingController(text: answer.points.toString());
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    contentPadding: const EdgeInsets.all(16.0),
                    content: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: pointsController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: 'course.quiz.option.answer.points.label'.tr(),
                                hintText: 'course.quiz.option.answer.points.hint'.tr()),
                          ),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                          child: Text('cancel'.tr().toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      TextButton(
                          child: Text('change'.tr().toUpperCase()),
                          onPressed: () async {
                            Navigator.pop(context);
                            updateQuestion(
                                bloc,
                                partBloc,
                                itemId,
                                questionId,
                                question.copyWith(
                                    answers: List<QuizAnswer>.from(question.answers!)
                                      ..[answerId] = answer.copyWith(
                                          points: int.tryParse(pointsController.text))));
                          })
                    ]));

        break;
    }
  }

  Future<void> updateQuestion(ServerEditorBloc bloc, CoursePartBloc partBloc, int itemId,
      int questionId, QuizQuestion question) async {
    var courseBloc = bloc.getCourse(partBloc.course!);
    var part = courseBloc.getCoursePart(partBloc.part!);
    var item = part.items[itemId] as QuizPartItem;
    var coursePart = part.copyWith(
        items: List<PartItem>.from(part.items)
          ..[itemId] = item.copyWith(
              questions: List<QuizQuestion>.from(item.questions)..[questionId] = question));
    courseBloc.updateCoursePart(coursePart);
    await bloc.save();
    partBloc.partSubject.add(coursePart);
  }
}
