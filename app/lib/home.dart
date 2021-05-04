import 'dart:convert';
import 'dart:math';

import 'package:dev_doctor/widgets/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

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
                  child: Wrap(alignment: WrapAlignment.center, children: [
                    ElevatedButton.icon(
                        onPressed: () => launch("https://docs.dev-doctor.cf/backend/own"),
                        icon: Icon(Icons.description_outlined,
                            color: Theme.of(context).primaryIconTheme.color),
                        label: Text("docs".tr().toUpperCase(),
                            style: Theme.of(context).primaryTextTheme.button)),
                    OutlinedButton.icon(
                        onPressed: () => launch("https://discord.linwood.tk"),
                        icon: Icon(Icons.supervisor_account_outlined),
                        label: Text("discord".tr().toUpperCase()))
                  ])),
              if (kIsWeb)
                Padding(
                    padding: EdgeInsets.all(5),
                    child: RawMaterialButton(
                        onPressed: () =>
                            launch("https://vercel.com?utm_source=Linwood&utm_campaign=oss"),
                        child: SizedBox(
                            height: 50,
                            child: SvgPicture.asset("images/powered-by-vercel.svg",
                                placeholderBuilder: (BuildContext context) => Container(
                                    padding: const EdgeInsets.all(30.0),
                                    child: const CircularProgressIndicator()),
                                semanticsLabel: 'Powered by Vercel'))))
            ]))
      ]),
      Column(children: [
        Text(
          "News",
          style: Theme.of(context).textTheme.headline4,
        ),
        Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: () => launch("https://linwood.tk/blog"),
              icon: Icon(Icons.open_in_new_outlined),
              label: Text("browser".tr().toUpperCase()),
            )),
        Padding(
            padding: EdgeInsets.all(20),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [])),
        FutureBuilder<http.Response>(
            future: http.get(Uri.https('linwood.tk', '/blog/atom.xml')),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Text("Error ${snapshot.error}");
              var data = utf8.decode(snapshot.data!.bodyBytes);
              var document = XmlDocument.parse(data);
              var feed = document.getElement("feed")!;
              var items = feed.findAllElements("entry").toList();
              return Column(
                children: List.generate(min(items.length, 10), (index) {
                  var entry = items[index];
                  return ListTile(
                    title: Text(entry.getElement("title")?.innerText ?? ''),
                    subtitle: Text(entry.getElement("summary")?.innerText ?? ''),
                    onTap: () => launch(entry.getElement("link")?.getAttribute("href") ?? ''),
                    isThreeLine: true,
                  );
                }),
              );
            })
      ])
    ];
    return Scaffold(
        appBar: MyAppBar(title: 'home'.tr()),
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
