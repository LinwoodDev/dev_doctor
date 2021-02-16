import 'package:flutter/material.dart';
import 'classic.dart' as classic;
import 'modern.dart' as modern;
import 'artistic.dart' as artistic;

enum ColorTheme { classic, modern, artistic }

extension ColorThemeExtension on ColorTheme {
  Color get mdcThemePrimary {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemePrimary;
      case ColorTheme.modern:
        return modern.mdcThemePrimary;
      case ColorTheme.artistic:
        return artistic.mdcThemePrimary;
    }
    return null;
  }

  Color get mdcThemeOnPrimary {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeOnPrimary;
      case ColorTheme.modern:
        return modern.mdcThemeOnPrimary;
      case ColorTheme.artistic:
        return artistic.mdcThemeOnPrimary;
    }
    return null;
  }

  Color get mdcThemeSecondary {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeSecondary;
      case ColorTheme.modern:
        return modern.mdcThemeSecondary;
      case ColorTheme.artistic:
        return artistic.mdcThemeSecondary;
    }
    return null;
  }

  Color get mdcThemeOnSecondary {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeOnSecondary;
      case ColorTheme.modern:
        return modern.mdcThemeOnSecondary;
      case ColorTheme.artistic:
        return artistic.mdcThemeOnSecondary;
    }
    return null;
  }

  Color get mdcThemeBackground {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeBackground;
      case ColorTheme.modern:
        return modern.mdcThemeBackground;
      case ColorTheme.artistic:
        return artistic.mdcThemeBackground;
    }
    return null;
  }

  Color get mdcThemeError {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeError;
      case ColorTheme.modern:
        return modern.mdcThemeError;
      case ColorTheme.artistic:
        return artistic.mdcThemeError;
    }
    return null;
  }

  Color get mdcThemeOnError {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeOnError;
      case ColorTheme.modern:
        return modern.mdcThemeOnError;
      case ColorTheme.artistic:
        return artistic.mdcThemeOnError;
    }
    return null;
  }

  Color get mdcThemeSurface {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeSurface;
      case ColorTheme.modern:
        return modern.mdcThemeSurface;
      case ColorTheme.artistic:
        return artistic.mdcThemeSurface;
    }
    return null;
  }

  Color get mdcThemeOnSurface {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcThemeOnSurface;
      case ColorTheme.modern:
        return modern.mdcThemeOnSurface;
      case ColorTheme.artistic:
        return artistic.mdcThemeOnSurface;
    }
    return null;
  }

  MaterialColor get mdcPrimarySwatch {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcPrimarySwatch;
      case ColorTheme.modern:
        return modern.mdcPrimarySwatch;
      case ColorTheme.artistic:
        return artistic.mdcPrimarySwatch;
    }
    return null;
  }

  String get mdcTypographyFontFamily {
    switch (this) {
      case ColorTheme.classic:
        return classic.mdcTypographyFontFamily;
      case ColorTheme.modern:
        return modern.mdcTypographyFontFamily;
      case ColorTheme.artistic:
        return artistic.mdcTypographyFontFamily;
    }
    return null;
  }
}
