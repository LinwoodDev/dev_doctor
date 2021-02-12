import 'dart:ui';

import 'package:flutter/material.dart';

final mdcThemePrimary = Color(0xFF5c3070);
const mdcThemeOnPrimary = Color(0xFFffffff);
const mdcThemeSecondary = Color(0xFF304470);
const mdcThemeOnSecondary = Color(0xFF000000);
const mdcThemeError = Color(0xFFb00020);
const mdcThemeOnError = Color(0xFFffffff);
const mdcThemeSurface = Color(0xFFffffff);
const mdcThemeOnSurface = Color(0xFF000000);
const mdcThemeBackground = Color(0xFFffffff);
final mdcTypographyFontFamily = "BellotaText";
final mdcPrimarySwatch = MaterialColor(mdcThemePrimary.value, {
  50: mdcThemePrimary.withOpacity(.1),
  100: mdcThemePrimary.withOpacity(.2),
  200: mdcThemePrimary.withOpacity(.3),
  300: mdcThemePrimary.withOpacity(.4),
  400: mdcThemePrimary.withOpacity(.5),
  500: mdcThemePrimary.withOpacity(.6),
  600: mdcThemePrimary.withOpacity(.7),
  700: mdcThemePrimary.withOpacity(.8),
  800: mdcThemePrimary.withOpacity(.9),
  900: mdcThemePrimary.withOpacity(1),
});
