import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:randomquotes/helpers/app_cache_helper.dart';
import 'package:randomquotes/helpers/device_helper.dart';
import 'package:randomquotes/util/localization.dart';

class AppSettings {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
  );

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('tr'),
  ];

  static String selectedLang = 'en';
  static String userId = '';

  static void loadDefaultLanguage(BuildContext context) {
    selectedLang = AppLocalizations.of(context).locale.languageCode.toString();
  }

  static Future<void> loadUserId() async {
    final storedUserId = await AppCacheHelper.getUserId();
    if (storedUserId != null) {
      userId = storedUserId;
    } else {
      final newUserId = DeviceHelper.generateUserId();
      await AppCacheHelper.saveUserId(newUserId);
      userId = newUserId;
    }
    if (kDebugMode) {
      print('=====> loadUserId: ' + userId);
    }
  }

  static const List<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale? localeResolutionCallback(locale, supportedLocales) {
    if (locale != null) {
      final currentLocale = supportedLocales
          .firstWhere((x) => x.languageCode == locale.languageCode);
      if (currentLocale != null) {
        selectedLang = currentLocale.languageCode.toString();
        return currentLocale;
      }
    }
    return supportedLocales.first;
  }
}
