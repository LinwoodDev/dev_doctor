import 'package:dev_doctor/models/item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';

class QuizPartItem extends PartItem {
  final String text;
  final List<QuizQuestion> questions;
  final int time;

  QuizPartItem(
      {this.text, this.time, this.questions = const [], String name, String description, int index})
      : super(name: name, description: description, index: index);
  @override
  QuizPartItem.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        time = json['time'],
        questions = (json['questions'] as List<dynamic> ?? [])
            .map((question) => QuizQuestion.fromJson(question))
            .toList(),
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "text": text,
        "time": time,
        "type": "quiz",
        "questions": questions.map((e) => e.toJson()).toList(),
        "name": name,
        "description": description
      };

  QuizPartItem copyWith(
          {String text, int time, List<QuizQuestion> questions, String name, String description}) =>
      QuizPartItem(
          name: name ?? this.name,
          description: description ?? this.description,
          index: index,
          questions: questions ?? this.questions,
          text: text ?? this.text,
          time: time ?? this.time);
}

@immutable
class QuizQuestion {
  final String title;
  final String description;
  final String evaluation;
  final List<QuizAnswer> answers;

  QuizQuestion({this.title, this.description, this.answers, this.evaluation});
  QuizQuestion.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        evaluation = json['evaluation'],
        answers = (json['answers'] as List<dynamic>)
            .map((answer) => QuizAnswer.fromJson(answer))
            .toList();
  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "evaluation": evaluation,
        "answers": answers.map((e) => e.toJson())
      };
  QuizQuestion copyWith(
          {String title, String description, String evaluation, List<QuizAnswer> answers}) =>
      QuizQuestion(
          answers: answers ?? this.answers,
          description: description ?? this.description,
          evaluation: evaluation ?? this.evaluation,
          title: title ?? this.title);
}

@immutable
class QuizAnswer {
  final bool correct;
  final String name;
  final String description;
  final int points;

  QuizAnswer({this.correct, this.name, this.description, this.points});
  QuizAnswer.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        correct = json['correct'] ?? false,
        points = json['points'];
  Map<String, dynamic> toJson() =>
      {"correct": correct, "name": name, "description": description, "points": points};
  QuizAnswer copyWith({String name, String description, bool correct, int points}) => QuizAnswer(
      correct: correct ?? this.correct,
      description: description ?? this.description,
      name: name ?? this.name,
      points: points ?? this.points);
}
