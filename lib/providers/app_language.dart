import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage with ChangeNotifier {
  static const _languageKey = 'language-code';
  Locale _currentLanguage = Locale("en");

  Locale get appLocal => _currentLanguage;

  bool get isRTl {
    return _currentLanguage.languageCode.contains('ar');
  }

  String get currentFont {
    if (_currentLanguage.languageCode.contains('en')) return 'helvetica';
    return 'cairo';
  }

  fetchLocal() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_languageKey)) {
      return Null;
    }
    _currentLanguage = Locale(prefs.getString(_languageKey));
    return Null;
  }

  void changeLanguage() async {
    String currentCode = _currentLanguage.languageCode;
    String local = 'en';

    if (currentCode.contains('en')) {
      local = 'ar';
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, local);
    _currentLanguage = Locale(local);
    notifyListeners();
  }
}
