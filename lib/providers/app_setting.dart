import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSetting with ChangeNotifier {
  final _languageKey = 'language-code';
  final _themeKey = 'theme-mode';
  Locale _currentLanguage = Locale("en");

  ThemeMode _themeMode = ThemeMode.light;

  bool get isDark => _themeMode == ThemeMode.dark;

  void changeTheme(bool isDarkvalue) async {
    _themeMode = isDarkvalue ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkvalue);
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

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
    if (prefs.containsKey(_languageKey)) {
      _currentLanguage = Locale(prefs.getString(_languageKey));
    }
    if (prefs.containsKey(_themeKey))
      _themeMode = prefs.getBool(_themeKey) ? ThemeMode.dark : ThemeMode.light;
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
