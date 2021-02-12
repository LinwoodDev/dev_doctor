import 'package:dev_doctor/models/item.dart';
import 'package:flutter/foundation.dart';

class QuizPartItem extends PartItem {
  final String text;
  final List<QuizQuestion> questions;
  final int time;

  QuizPartItem({this.text, this.time, this.questions, String name, String description, int index})
      : super(name: name, description: description, index: index);
  @override
  QuizPartItem.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        time = json['time'],
        questions = (json['questions'] as List<dynamic>)
            .map((question) => QuizQuestion.fromJson(question))
            .toList(),
        super.fromJson(json);
}

@immutable
class QuizQuestion {
  final String title;
  final String description;
  final List<QuizAnswer> answers;

  QuizQuestion({this.title, this.description, this.answers});
  QuizQuestion.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        answers = (json['answers'] as List<dynamic>)
            .map((answer) => QuizAnswer.fromJson(answer))
            .toList();
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
}
