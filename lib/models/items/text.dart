import 'package:dev_doctor/models/item.dart';

class TextPartItem extends PartItem {
  final String text;

  TextPartItem({this.text = "", String name, String description, int index})
      : super(name: name, description: description, index: index);
  @override
  TextPartItem.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        super.fromJson(json);

  Map<String, dynamic> toJson() => {"type": "text", "text": text};

  TextPartItem copyWith({String text, String name, String description}) => TextPartItem(
      text: text ?? this.text,
      description: description ?? this.description,
      index: index,
      name: name ?? this.name);
}
