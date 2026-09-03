import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageProvider =
    ChangeNotifierProvider.autoDispose((ref) => LanguageState());

class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String shortCode;
  final String? fontFamily;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.shortCode,
    this.fontFamily,
  });
}

class LanguageState extends ChangeNotifier {
  static const String _languagePreferenceKey = 'app_language';
  static const String ENGLISH = 'en';
  static const String TIBETAN = 'bo';
  static const String HINDI = 'hi';

  static const List<AppLanguage> supportedLanguages = [
    AppLanguage(
      code: TIBETAN,
      name: 'Tibetan',
      nativeName: 'བོད་ཡིག',
      shortCode: 'བོད',
    ),
    AppLanguage(
      code: ENGLISH,
      name: 'English',
      nativeName: 'EN',
      shortCode: 'EN',
      fontFamily: 'Roboto',
    ),
    AppLanguage(
      code: HINDI,
      name: 'Hindi',
      nativeName: 'हिन्दी',
      shortCode: 'हिं',
      fontFamily: 'Roboto',
    ),
  ];

  LanguageState() {
    _loadLanguage();
  }

  String? _currentLanguage;

  String get currentLanguage => _currentLanguage ?? ENGLISH;

  AppLanguage get currentLanguageModel {
    return supportedLanguages.firstWhere(
      (lang) => lang.code == currentLanguage,
      orElse: () => supportedLanguages[0],
    );
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languagePreferenceKey) ?? TIBETAN;
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languagePreferenceKey, language);
      notifyListeners();
    }
  }
}
