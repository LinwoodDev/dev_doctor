import 'package:flutter/material.dart';

class ImageTypeDropdown extends StatefulWidget {
  final String? defaultValue;
  final ValueChanged<String?>? onChanged;

  const ImageTypeDropdown({Key? key, this.defaultValue, this.onChanged}) : super(key: key);
  @override
  _ImageTypeDropdownState createState() => _ImageTypeDropdownState();
}

class _ImageTypeDropdownState extends State<ImageTypeDropdown> {
  String? dropdownValue;
  @override
  void initState() {
    dropdownValue = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue;
          widget.onChanged!(newValue);
        });
      },
      items: <String>['svg', 'png', 'jpg', 'jpeg'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
