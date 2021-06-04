import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "article.title".tr(), actions: [
        IconButton(tooltip: "like".tr(), icon: Icon(Icons.search), onPressed: () {}),
      ]),
    );
  }
}
