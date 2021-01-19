import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Dev-Doctor'),
      body: ListView(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Container(
                  child: Column(children: [
                Text(
                  "Dev-Doctor",
                  style: Theme.of(context).textTheme.headline2,
                ),
                Text("A free, opensource, serverless learning platform. A linwood project",
                    style: Theme.of(context).textTheme.subtitle1),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      RaisedButton.icon(
                        icon: Icon(Icons.list_outlined,
                            color: Theme.of(context).primaryIconTheme.color),
                        label:
                            Text("VIEW COURSES", style: Theme.of(context).primaryTextTheme.button),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {},
                      ),
                      OutlinedButton.icon(
                        icon: Icon(Icons.supervisor_account_outlined),
                        label: Text("JOIN OUR DISCORD"),
                        onPressed: () {},
                      )
                    ]))
              ])))
        ],
      ),
    );
  }
}
