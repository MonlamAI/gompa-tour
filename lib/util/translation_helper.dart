class TranslationHelper {
  static String getTranslatedField<T>({
    required List<T>? translations,
    required String languageCode,
    required String Function(T) fieldGetter,
  }) {
    if (translations == null || translations.isEmpty) return '';
    try {
      // 1. Try requested language
      final target = translations.where(
        (t) =>
            (t as dynamic).languageCode.toString().toLowerCase() ==
            languageCode.toLowerCase(),
      );
      if (target.isNotEmpty) {
        final text = fieldGetter(target.first);
        if (text.trim().isNotEmpty) {
          return text;
        }
      }

      // 2. Fallback to English ('en')
      final english = translations.where(
        (t) => (t as dynamic).languageCode.toString().toLowerCase() == 'en',
      );
      if (english.isNotEmpty) {
        final text = fieldGetter(english.first);
        if (text.trim().isNotEmpty) {
          return text;
        }
      }

      // 3. Fallback to first available non-empty translation
      for (final item in translations) {
        final text = fieldGetter(item);
        if (text.trim().isNotEmpty) {
          return text;
        }
      }

      return '';
    } catch (e) {
      return '';
    }
  }
}


