import 'package:dev_doctor/models/author.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

import 'image.dart';

@immutable
class AuthorDisplay extends StatelessWidget {
  final Author author;
  final bool editing;

  const AuthorDisplay({Key? key, required this.author, this.editing = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return author.name.isEmpty
        ? Container()
        : GestureDetector(
            onTap: () {
              if (author.url.isNotEmpty) launch(author.url);
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (author.avatar.isNotEmpty)
                Padding(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                        child: ClipOval(
                            child: UniversalImage(url: author.avatar, type: author.avatarType)))),
              Text(author.name.isEmpty
                  ? editing
                      ? 'course.author.notset'.tr()
                      : ''
                  : author.name),
            ]));
  }
}
