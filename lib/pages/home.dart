import 'package:dev_doctor/widgets/appbar.dart';
import 'package:dev_doctor/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatelessWidget {
  final GlobalKey _coursesKey = GlobalKey();
  final Box _settingsBox = Hive.box('settings');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Dev-Doctor'),
      bottomNavigationBar: MyBottomNavigationBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        children: [
          Material(
              elevation: 2,
              child: Container(
                  child: Column(children: [
                Text(
                  "Dev-Doctor",
                  style: Theme.of(context).textTheme.headline2,
                ),
                Text("A free, opensource, serverless learning platform. A linwood project",
                    style: Theme.of(context).textTheme.subtitle1),
                if (_settingsBox.containsKey('name'))
                  Text("Welcome back, ${_settingsBox.get('name')}"),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: RaisedButton.icon(
                            icon: Icon(Icons.list_outlined,
                                color: Theme.of(context).primaryIconTheme.color),
                            label: Text("VIEW COURSES",
                                style: Theme.of(context).primaryTextTheme.button),
                            color: Theme.of(context).primaryColor,
                            onPressed: () => Scrollable.ensureVisible(_coursesKey.currentContext),
                          )),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: OutlineButton.icon(
                            icon: Icon(Icons.supervisor_account_outlined),
                            label: Text("JOIN OUR DISCORD"),
                            onPressed: () {},
                          ))
                    ]))
              ]))),
          Material(
              elevation: 2,
              child: Container(
                  key: _coursesKey,
                  child: Column(children: [
                    Text(
                      "Courses",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: []))
                  ])))
        ],
      ),
    );
  }
}
