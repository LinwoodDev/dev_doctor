import 'package:flutter/material.dart';

class ImageTypeDropdown extends StatefulWidget {
  final String? defaultValue;
  final ValueChanged<String> onChanged;

  const ImageTypeDropdown(
      {Key? key, this.defaultValue, required this.onChanged})
      : super(key: key);
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
        if (newValue != null)
          setState(() {
            widget.onChanged(newValue);
            dropdownValue = newValue;
          });
      },
      items: <String>['svg', 'png', 'jpg', 'jpeg']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
