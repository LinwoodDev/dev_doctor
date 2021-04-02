import 'package:flutter/material.dart';
import 'classic.dart' as classic;
import 'modern.dart' as modern;
import 'artistic.dart' as artistic;
import 'spring.dart' as spring;
import 'summer.dart' as summer;
import 'autumn.dart' as autumn;
import 'winter.dart' as winter;

enum ColorTheme { classic, modern, artistic, spring, summer, autumn, winter }

extension ColorThemeExtension on ColorTheme {
  Color get mdcThemePrimary {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemePrimary;
      case ColorTheme.modern:
        return modern.mdcThemePrimary;
      case ColorTheme.artistic:
        return artistic.mdcThemePrimary;
      case ColorTheme.spring:
        return spring.mdcThemePrimary;
      case ColorTheme.summer:
        return summer.mdcThemePrimary;
      case ColorTheme.autumn:
        return autumn.mdcThemePrimary;
      case ColorTheme.winter:
        return winter.mdcThemePrimary;
    }
  }

  Color get mdcThemeOnPrimary {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeOnPrimary;
      case ColorTheme.modern:
        return modern.mdcThemeOnPrimary;
      case ColorTheme.artistic:
        return artistic.mdcThemeOnPrimary;
      case ColorTheme.spring:
        return spring.mdcThemeOnPrimary;
      case ColorTheme.summer:
        return summer.mdcThemeOnPrimary;
      case ColorTheme.autumn:
        return autumn.mdcThemeOnPrimary;
      case ColorTheme.winter:
        return winter.mdcThemeOnPrimary;
    }
  }

  Color get mdcThemeSecondary {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeSecondary;
      case ColorTheme.modern:
        return modern.mdcThemeSecondary;
      case ColorTheme.artistic:
        return artistic.mdcThemeSecondary;
      case ColorTheme.spring:
        return spring.mdcThemeSecondary;
      case ColorTheme.summer:
        return summer.mdcThemeSecondary;
      case ColorTheme.autumn:
        return autumn.mdcThemeSecondary;
      case ColorTheme.winter:
        return winter.mdcThemeSecondary;
    }
  }

  Color get mdcThemeOnSecondary {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeOnSecondary;
      case ColorTheme.modern:
        return modern.mdcThemeOnSecondary;
      case ColorTheme.artistic:
        return artistic.mdcThemeOnSecondary;
      case ColorTheme.spring:
        return spring.mdcThemeOnSecondary;
      case ColorTheme.summer:
        return summer.mdcThemeOnSecondary;
      case ColorTheme.autumn:
        return autumn.mdcThemeOnSecondary;
      case ColorTheme.winter:
        return winter.mdcThemeOnSecondary;
    }
  }

  Color get mdcThemeBackground {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeBackground;
      case ColorTheme.modern:
        return modern.mdcThemeBackground;
      case ColorTheme.artistic:
        return artistic.mdcThemeBackground;
      case ColorTheme.spring:
        return spring.mdcThemeBackground;
      case ColorTheme.summer:
        return summer.mdcThemeBackground;
      case ColorTheme.autumn:
        return autumn.mdcThemeBackground;
      case ColorTheme.winter:
        return winter.mdcThemeBackground;
    }
  }

  Color get mdcThemeError {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeError;
      case ColorTheme.modern:
        return modern.mdcThemeError;
      case ColorTheme.artistic:
        return artistic.mdcThemeError;
      case ColorTheme.spring:
        return spring.mdcThemeError;
      case ColorTheme.summer:
        return summer.mdcThemeError;
      case ColorTheme.autumn:
        return autumn.mdcThemeError;
      case ColorTheme.winter:
        return winter.mdcThemeError;
    }
  }

  Color get mdcThemeOnError {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeOnError;
      case ColorTheme.modern:
        return modern.mdcThemeOnError;
      case ColorTheme.artistic:
        return artistic.mdcThemeOnError;
      case ColorTheme.spring:
        return spring.mdcThemeOnError;
      case ColorTheme.summer:
        return summer.mdcThemeOnError;
      case ColorTheme.autumn:
        return autumn.mdcThemeOnError;
      case ColorTheme.winter:
        return winter.mdcThemeOnError;
    }
  }

  Color get mdcThemeSurface {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeSurface;
      case ColorTheme.modern:
        return modern.mdcThemeSurface;
      case ColorTheme.artistic:
        return artistic.mdcThemeSurface;
      case ColorTheme.spring:
        return spring.mdcThemeSurface;
      case ColorTheme.summer:
        return summer.mdcThemeSurface;
      case ColorTheme.autumn:
        return autumn.mdcThemeSurface;
      case ColorTheme.winter:
        return winter.mdcThemeSurface;
    }
  }

  Color get mdcThemeOnSurface {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeOnSurface;
      case ColorTheme.modern:
        return modern.mdcThemeOnSurface;
      case ColorTheme.artistic:
        return artistic.mdcThemeOnSurface;
      case ColorTheme.spring:
        return spring.mdcThemeOnSurface;
      case ColorTheme.summer:
        return summer.mdcThemeOnSurface;
      case ColorTheme.autumn:
        return autumn.mdcThemeOnSurface;
      case ColorTheme.winter:
        return winter.mdcThemeOnSurface;
    }
  }

  MaterialColor get mdcPrimarySwatch {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcPrimarySwatch;
      case ColorTheme.modern:
        return modern.mdcPrimarySwatch;
      case ColorTheme.artistic:
        return artistic.mdcPrimarySwatch;
      case ColorTheme.spring:
        return spring.mdcPrimarySwatch;
      case ColorTheme.summer:
        return summer.mdcPrimarySwatch;
      case ColorTheme.autumn:
        return autumn.mdcPrimarySwatch;
      case ColorTheme.winter:
        return winter.mdcPrimarySwatch;
    }
  }

  String get mdcTypographyFontFamily {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcTypographyFontFamily;
      case ColorTheme.modern:
        return modern.mdcTypographyFontFamily;
      case ColorTheme.artistic:
        return artistic.mdcTypographyFontFamily;
      case ColorTheme.spring:
        return spring.mdcTypographyFontFamily;
      case ColorTheme.summer:
        return summer.mdcTypographyFontFamily;
      case ColorTheme.autumn:
        return autumn.mdcTypographyFontFamily;
      case ColorTheme.winter:
        return winter.mdcTypographyFontFamily;
    }
  }
}
