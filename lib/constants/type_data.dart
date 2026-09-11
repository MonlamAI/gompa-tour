class TypeData {
  static const Map<String, String> typeTranslations = {
    "MONASTERY": "དགོན་པ།",
    "NUNNERY": "བཙུན་དགོན།",
    "TEMPLE": "ལྷ་ཁང་།",
  };

  static const Map<String, String> typeHindiTranslations = {
    "MONASTERY": "मठ",
    "NUNNERY": "भिक्षुणी मठ",
    "TEMPLE": "मंदिर",
  };

  static String getLocalizedTypeName(
      String type, String languageCode) {
    final typeUpper = type.toUpperCase();
    if (languageCode == 'bo') {
      return typeTranslations[typeUpper] ?? typeUpper;
    } else if (languageCode == 'hi') {
      return typeHindiTranslations[typeUpper] ?? typeUpper;
    }
    return typeUpper;
  }
}
