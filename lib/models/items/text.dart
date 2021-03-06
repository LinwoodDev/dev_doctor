import 'package:dev_doctor/models/item.dart';

class TextPartItem extends PartItem {
  final String text;

  TextPartItem({this.text, String name, String description, int index})
      : super(name: name, description: description, index: index);
  @override
  TextPartItem.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        super.fromJson(json);
  Map<String, dynamic> toJson() => {"text": text};
}
