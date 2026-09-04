import 'package:flutter/material.dart';
import 'package:gompa_tour/util/translation_helper.dart';

class LocalizationHelper {
  static String getLocalizedField<T>(
    BuildContext context, {
    required List<T>? translations,
    required String Function(T) getter,
    int? maxLength,
  }) {
    if (translations == null || translations.isEmpty) return '';
    final locale = Localizations.localeOf(context);
    final text = TranslationHelper.getTranslatedField(
      translations: translations,
      languageCode: locale.languageCode,
      fieldGetter: getter,
    );

    if (maxLength != null && text.length > maxLength) {
      return "${text.substring(0, maxLength)}...";
    }

    return text.replaceAll(RegExp(r'\\r\\n|\\n'), '\n');
  }

  static String getLocalizedText(
    BuildContext context, {
    required String enText,
    required String tbText,
    String? hiText,
    String? defaultText,
    int? maxLength, // Added maxLength parameter
  }) {
    final locale = Localizations.localeOf(context);
    String localizedText;

    if (locale.languageCode == 'en') {
      localizedText = enText;
    } else if (locale.languageCode == 'bo') {
      localizedText = tbText;
    } else if (locale.languageCode == 'hi') {
      localizedText = (hiText != null && hiText.trim().isNotEmpty)
          ? hiText
          : (defaultText ?? enText);
    } else {
      localizedText = defaultText ?? enText; // Fallback to English if no match
    }

    if (maxLength != null && localizedText.length > maxLength) {
      return "${localizedText.substring(0, maxLength)}...";
    }

    return localizedText.replaceAll(RegExp(r'\\r\\n|\\n'), '\n');
  }

  static double? getLocalizedHeight(BuildContext buildContext) {
    final locale = Localizations.localeOf(buildContext);
    return locale.languageCode == 'bo' ? 2.0 : null;
  }
}

// Extension method for easier access
extension LocalizedTextExtension on BuildContext {
  String localizedField<T>({
    required List<T>? translations,
    required String Function(T) getter,
    int? maxLength,
  }) {
    return LocalizationHelper.getLocalizedField(
      this,
      translations: translations,
      getter: getter,
      maxLength: maxLength,
    );
  }

  String localizedText({
    required String enText,
    required String boText,
    String? hiText,
    String? defaultText,
    int? maxLength, // Added maxLength parameter
  }) {
    return LocalizationHelper.getLocalizedText(
      this,
      enText: enText,
      tbText: boText,
      hiText: hiText,
      defaultText: defaultText,
      maxLength: maxLength, // Pass maxLength to the helper method
    );
  }

  double? getLocalizedHeight() {
    return LocalizationHelper.getLocalizedHeight(
      this,
    );
  }
}

