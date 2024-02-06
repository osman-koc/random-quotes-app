import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:randomquotes/util/localization.dart';

class AppSettings {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
  );

  static const List<Locale> supportedLocales = [
    Locale('tr'),
    Locale('en'),
  ];

  static const List<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale? localeResolutionCallback(locale, supportedLocales) {
    if (locale != null) {
      final currentLocale = supportedLocales
          .firtWhere((x) => x.languageCode == locale.languageCode);
      if (currentLocale != null) return currentLocale;
    }
    return supportedLocales.first;
  }
}
