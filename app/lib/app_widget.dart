import 'package:dev_doctor/widgets/error.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dev_doctor/app_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'themes/theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // var locale = Hive.box('appearance').get('locale', defaultValue: 'default');
    //if (locale != 'default') context.locale = Locale.fromSubtags(scriptCode: locale);
    return EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('de'), Locale('fr')],
        path: 'translations',
        fallbackLocale: const Locale('en'),
        useOnlyLangCode: true,
        child: ValueListenableBuilder(
            valueListenable: Hive.box('appearance').listenable(),
            builder: (context, dynamic box, widget) {
              var color = Hive.box('appearance').get('color', defaultValue: 0);
              var colorTheme = ColorTheme.values[color];
              return MaterialApp.router(
                routeInformationParser: Modular.routeInformationParser,
                routerDelegate: Modular.routerDelegate,
                title: 'Dev-Doctor',
                localizationsDelegates: [
                  ...context.localizationDelegates,
                  const LocaleNamesLocalizationsDelegate()
                ],
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                themeMode: ThemeMode.values[box.get('theme', defaultValue: 0)],
                debugShowCheckedModeBanner: false,
                builder: (context, widget) {
                  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                    return const ErrorDisplay();
                  };

                  return widget ?? const ErrorDisplay();
                },
                theme: ThemeData(
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
                    primarySwatch: colorTheme.mdcPrimarySwatch,
                    colorScheme: ColorScheme.light(
                        primary: colorTheme.mdcThemePrimary,
                        secondary: colorTheme.mdcThemeSecondary,
                        error: colorTheme.mdcThemeError),
                    //canvasColor: colorTheme.mdcThemeSurface,
                    fontFamily: colorTheme.mdcTypographyFontFamily,
                    // This makes the visual density adapt to the platform that you run
                    // the app on. For desktop platforms, the controls will be smaller and
                    // closer together (more dense) than on mobile platforms.
                    visualDensity: VisualDensity.adaptivePlatformDensity),
                darkTheme: ThemeData(
                    brightness: Brightness.dark,
                    primarySwatch: colorTheme.mdcPrimarySwatch,
                    colorScheme: ColorScheme.dark(
                        primary: colorTheme.mdcThemePrimary,
                        secondary: colorTheme.mdcThemeSecondary,
                        error: colorTheme.mdcThemeError),
                    //canvasColor: colorTheme.mdcThemeSurface.,
                    fontFamily: colorTheme.mdcTypographyFontFamily,
                    // This makes the visual density adapt to the platform that you run
                    // the app on. For desktop platforms, the controls will be smaller and
                    // closer together (more dense) than on mobile platforms.
                    visualDensity: VisualDensity.adaptivePlatformDensity),
              );
            }));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedIndex = HomeRoutesExtension.fromRoute(Modular.to.path).index;
    super.initState();
  }

  void _onItemTapped(int index) {
    Modular.to.pushReplacementNamed(HomeRoutes.values[index].route);
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: RouterOutlet(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                activeIcon: const Icon(PhosphorIcons.houseFill),
                icon: const Icon(PhosphorIcons.houseLight),
                label: 'home'.tr()),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                activeIcon: const Icon(PhosphorIcons.storefrontFill),
                icon: const Icon(PhosphorIcons.storefrontLight),
                label: 'backends.title'.tr()),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                activeIcon: const Icon(PhosphorIcons.articleFill),
                icon: const Icon(PhosphorIcons.articleLight),
                label: 'articles.title'.tr()),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                activeIcon: const Icon(PhosphorIcons.graduationCapFill),
                icon: const Icon(PhosphorIcons.graduationCapLight),
                label: 'courses.title'.tr()),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                activeIcon: const Icon(PhosphorIcons.pencilFill),
                icon: const Icon(PhosphorIcons.pencilLight),
                label: 'editor.title'.tr()),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                activeIcon: const Icon(PhosphorIcons.gearFill),
                icon: const Icon(PhosphorIcons.gearLight),
                label: 'settings.title'.tr())
          ],
          unselectedItemColor: Theme.of(context).unselectedWidgetColor,
          selectedItemColor: Theme.of(context).selectedRowColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped),
    );
  }
}
