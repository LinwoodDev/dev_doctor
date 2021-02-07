import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton.icon(
                      onPressed: () => launch("https://discord.linwood.tk"),
                      icon: Icon(Icons.supervisor_account_outlined,
                          color: Theme.of(context).primaryIconTheme.color),
                      label: Text("discord".tr().toUpperCase(),
                          style: Theme.of(context).primaryTextTheme.button))),
              if (kIsWeb)
                Padding(
                    padding: EdgeInsets.all(5),
                    child: RawMaterialButton(
                        onPressed: () =>
                            launch("https://vercel.com?utm_source=Linwood&utm_campaign=oss"),
                        child: SvgPicture.asset("images/powered-by-vercel.svg",
                            semanticsLabel: 'Powered by Vercel'))),
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
