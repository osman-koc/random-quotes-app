import 'package:flutter/material.dart';
import 'package:randomquotes/util/localization.dart';

class AppLangTranslations {
  final AppLocalizations _appLocalizations;

  AppLangTranslations(this._appLocalizations);

  String get appName => _appLocalizations.translate(key: 'app_name');
  String get appDeveloper => _appLocalizations.translate(key: 'app_developer');
  String get appWebsite => _appLocalizations.translate(key: 'app_website');
  String get appMail => _appLocalizations.translate(key: 'app_email');
  String get loading => _appLocalizations.translate(key: 'loading');
  String get osmkocCom => _appLocalizations.translate(key: 'osmkoccom');
  String get aboutAppTitle => _appLocalizations.translate(key: 'about_app_title');
  String get developedBy => _appLocalizations.translate(key: 'developedby');
  String get contact => _appLocalizations.translate(key: 'contact');
  String get close => _appLocalizations.translate(key: 'close');
}

extension AppLangContextExtension on BuildContext {
  AppLangTranslations get translate =>
      AppLangTranslations(AppLocalizations.of(this));
}
