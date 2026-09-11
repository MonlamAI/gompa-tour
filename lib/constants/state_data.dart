/// Contains mapping of state names between English, Tibetan, and Hindi
class StateData {
  /// Map of state names with English (uppercase) as keys and Tibetan as values
  static const Map<String, String> stateTranslationsForGonpa = {
    "ARUNACHAL PRADESH": "ཨ་རུ་ཎཱ་ཅལ།",
    "BIHAR": "བི་ཧཱར།",
    "CHHATTISGARH": "ཆ་ཏྟཱིས་གར།",
    "DELHI": "དིལླཱི།",
    "HIMACHAL PRADESH": "ཧི་མཱ་ཅལ།",
    "KARNATAKA": "ཀརནཱ་ཊཀ།",
    "LADAKH": "ལ་དྭགས།",
    "MEGHALAYA": "མེ་གྷཱ་ལ་ཡ།",
    "MADHYA PRADESH": "མདྱ། པྲདེཤ",
    "MAHARASHTRA": "མཧཱ་རཥཊྲ།",
    "ODISHA": "ཨོ་ཌི་ཤཱ།",
    "SIKKIM": "འབྲས་ལྗོངས།",
    "UTTAR PRADESH": "ཨུཏྟར། པྲདེཤ།",
    "UTTARAKHAND": "ཨུཏྟརཱ་ཁནྜ།",
    "WEST BENGAL": "ནུབ་བངྒཱལ།",
    "KATHMANDU": "ཀ་ཐ་མན་གྲུ།",
    "LUMBINI": "ལུམ་བི་ཎི།",
    "POKHARA": "སྤོག་ར།",
    "SOLOKHUMBU": "སོ་ལོ་ཁམ་བུ།",
  };

  /// Map of state names with English (uppercase) as keys and Hindi as values
  static const Map<String, String> stateHindiTranslationsForGonpa = {
    "ARUNACHAL PRADESH": "अरुणाचल प्रदेश",
    "BIHAR": "बिहार",
    "CHHATTISGARH": "छत्तीसगढ़",
    "DELHI": "दिल्ली",
    "HIMACHAL PRADESH": "हिमाचल प्रदेश",
    "KARNATAKA": "कर्नाटक",
    "LADAKH": "लद्दाख",
    "MEGHALAYA": "मेघालय",
    "MADHYA PRADESH": "मध्य प्रदेश",
    "MAHARASHTRA": "महाराष्ट्र",
    "ODISHA": "ओडिशा",
    "SIKKIM": "सिक्किम",
    "UTTAR PRADESH": "उत्तर प्रदेश",
    "UTTARAKHAND": "उत्तराखंड",
    "WEST BENGAL": "पश्चिम बंगाल",
    "KATHMANDU": "काठमांडू",
    "LUMBINI": "लुंबिनी",
    "POKHARA": "पोखरा",
    "SOLOKHUMBU": "सोलुखुम्बु",
  };

  /// Map of state names with English (uppercase) as keys and Tibetan as values for Pilgrimage
  static const Map<String, String> stateTranslationForPilgrim = {
    "ANDHRA PRADESH": "ཨན་དྷ་ར་པྲདེ་ཤ།",
    "ARUNACHAL PRADESH": "ཨ་རུ་ཎཱ་ཅལ།",
    "BIHAR": "བི་ཧཱར།",
    "DELHI": "དིལླཱི།",
    "HIMACHAL PRADESH": "ཧི་མཱ་ཅལ།",
    "MADHYA PRADESH": "མདྱ། པྲདེཤ",
    "MAHARASHTRA": "མཧཱ་རཥཊྲ།",
    "UTTAR PRADESH": "ཨུཏྟར། པྲདེཤ།",
    "UTTARAKHAND": "ཨུཏྟརཱ་ཁནྜ།",
    "LUMBINI": "ལུམ་བི་ཎི།",
  };

  /// Map of state names with English (uppercase) as keys and Hindi as values for Pilgrimage
  static const Map<String, String> stateHindiTranslationForPilgrim = {
    "ANDHRA PRADESH": "आंध्र प्रदेश",
    "ARUNACHAL PRADESH": "अरुणाचल प्रदेश",
    "BIHAR": "बिहार",
    "DELHI": "दिल्ली",
    "HIMACHAL PRADESH": "हिमाचल प्रदेश",
    "MADHYA PRADESH": "मध्य प्रदेश",
    "MAHARASHTRA": "महाराष्ट्र",
    "UTTAR PRADESH": "उत्तर प्रदेश",
    "UTTARAKHAND": "उत्तराखंड",
    "LUMBINI": "लुंबिनी",
  };

  /// Get the localized state name based on the current locale
  static String getLocalizedStateNameForGonpa(
      String state, String languageCode) {
    final stateUpper = state.toUpperCase();
    if (languageCode == 'bo') {
      return stateTranslationsForGonpa[stateUpper] ?? stateUpper;
    } else if (languageCode == 'hi') {
      return stateHindiTranslationsForGonpa[stateUpper] ?? stateUpper;
    }
    return stateUpper;
  }

  // Get the localized state name based on the current locale for Pilgrimage
  static String getLocalizedStateNameForPilgrim(
      String state, String languageCode) {
    final stateUpper = state.toUpperCase();
    if (languageCode == 'bo') {
      return stateTranslationForPilgrim[stateUpper] ?? stateUpper;
    } else if (languageCode == 'hi') {
      return stateHindiTranslationForPilgrim[stateUpper] ?? stateUpper;
    }
    return stateUpper;
  }
}
