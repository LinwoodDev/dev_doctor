import 'package:dev_doctor/app_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'generated/l10n.dart';

class AppWidget extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        // ... app-specific localization delegate[s] here
        // TODO: uncomment the line below after codegen
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Dev-Doctor',
      supportedLocales: S.delegate.supportedLocales,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Roboto",
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        /* appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black87),
            textTheme: Theme.of(context).textTheme.merge(Typography.material2018().black).apply()), */
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    ).modular();
  }
}

class MyHomePage extends StatefulWidget {
  final ModularArguments args;

  const MyHomePage({Key key, this.args}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex;

  @override
  void initState() {
    print(widget.args.uri.path);
    super.initState();
  }

  void _onItemTapped(int index) {
    Modular.to.navigate(HomeRoutesExtension.fromIndex(index).route, replaceAll: true);
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RouterOutlet(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                activeIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'Home'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                activeIcon: Icon(Icons.school),
                icon: Icon(Icons.school_outlined),
                label: 'Courses'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                activeIcon: Icon(Icons.create),
                icon: Icon(Icons.create_outlined),
                label: 'Editor'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                activeIcon: Icon(Icons.settings),
                icon: Icon(Icons.settings_outlined),
                label: 'Settings')
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped),
    );
  }
}
