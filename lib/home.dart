import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _sections = [
      Column(children: [
        Text(
          "title".tr(),
          style: Theme.of(context).textTheme.headline2,
        ),
        Text("subtitle", style: Theme.of(context).textTheme.subtitle1).tr(),
        Padding(
            padding: EdgeInsets.all(20),
            child: Wrap(alignment: WrapAlignment.center, children: [
              Padding(
                  padding: EdgeInsets.all(5),
                  child: RaisedButton.icon(
                      onPressed: () => launch("https://discord.linwood.tk"),
                      icon: Icon(Icons.supervisor_account_outlined,
                          color: Theme.of(context).primaryIconTheme.color),
                      label: Text("discord".tr().toUpperCase(),
                          style: Theme.of(context).primaryTextTheme.button),
                      color: Theme.of(context).primaryColor)),
            ]))
      ]),
      Column(children: [
        Text(
          "News",
          style: Theme.of(context).textTheme.headline4,
        ),
        Padding(
            padding: EdgeInsets.all(20),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [])),
        Text("Coming soon...")
      ])
    ];
    return Scaffold(
        appBar: MyAppBar(title: 'title'.tr()),
        body: Scrollbar(
          child: ListView.separated(
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(top: 100),
            ),
            itemCount: _sections.length,
            padding: EdgeInsets.only(top: 100),
            itemBuilder: (context, index) => Material(
                elevation: 2,
                child: Container(padding: EdgeInsets.all(10), child: _sections[index])),
          ),
        ));
  }
}