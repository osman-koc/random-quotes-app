import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const List<String> supportedLangCodes = ['tr', 'en'];
  static const Locale defaultLocale = Locale('tr', 'TR');

  String getCurrentLangJsonFile() => 'assets/lang/${locale.languageCode}.json';

  static String getLanguageName(BuildContext context, String langCode) {
    switch (langCode) {
      case 'en':
        return 'English';
      case 'tr':
        return 'Türkçe';
      default:
        return langCode;
    }
  }

  static AppLocalizations of(BuildContext context) {
    var localeOf =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (localeOf != null) {
      return localeOf;
    } else {
      return AppLocalizations(defaultLocale);
    }
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings = <String, String>{};

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString(getCurrentLangJsonFile());
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  String translate({required String key}) {
    return _localizedStrings[key].toString();
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLangCodes.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    var localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
