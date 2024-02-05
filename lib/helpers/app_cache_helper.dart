import 'package:randomquotes/constants/app_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCacheHelper {
  static Future<String> getSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    var lang = prefs.getString(AppCache.selectedLanguageCode) ?? 'tr';
    return lang;
  }

  static Future<void> saveLanguagePreference(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppCache.selectedLanguageCode, language);
  }
}