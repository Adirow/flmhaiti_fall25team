import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const _localePreferenceKey = 'app_locale_code';

  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localePreferenceKey);
    if (code != null && code.isNotEmpty) {
      final newLocale = Locale(code);
      if (newLocale != _locale) {
        _locale = newLocale;
        notifyListeners();
      }
    }
  }

  Future<void> setLocale(Locale? locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_localePreferenceKey);
    } else {
      await prefs.setString(_localePreferenceKey, locale.languageCode);
    }
  }
}
