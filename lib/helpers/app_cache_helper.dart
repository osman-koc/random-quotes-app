import 'package:flutter/foundation.dart';
import 'package:randomquotes/constants/app_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCacheHelper {
  // Base Methods - Start
  static Future<String?> getPreferenceString(String code) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(code);
  }

  static Future<bool> savePreferenceString(String code, String data) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(code, data);
  }
  // Base Methods - End

  // Select Language - Start
  static Future<String> getSelectedLanguage() async {
    final lang = await getPreferenceString(AppCache.selectedLanguageCode);
    return lang ?? 'tr';
  }

  static Future<void> saveLanguagePreference(String language) async {
    await savePreferenceString(AppCache.selectedLanguageCode, language);
  }
  // Select Language - End


  // UserId - Start
  static Future<String?> getUserId() async {
    if (kDebugMode) {
      print('=====> getUserId method called. ');
    }
    final userId = await getPreferenceString(AppCache.userId);
    if (kDebugMode) {
      print('=====> getUserId result is ');
      print(userId);
    }
    return userId;
  }

  static Future<void> saveUserId(String newUserId) async {
    if (kDebugMode) {
      print('=====> saveUserId method called. ');
    }
    final isSuccess = await savePreferenceString(AppCache.userId, newUserId);
    if (kDebugMode) {
      print('=====> saveUserId result is ' + isSuccess.toString());
    }
    var savedUserId = await getPreferenceString(AppCache.userId);
    if (kDebugMode) {
      print('=====> savedUserId is ');
      print(savedUserId);
    }
  }
  // UserId - End

}
