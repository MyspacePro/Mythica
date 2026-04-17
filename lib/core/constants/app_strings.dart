import 'package:flutter/material.dart';

class AppStrings {
  AppStrings._();

  /// 🌍 Supported Languages
  static const supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('gu'),
  ];

  /// 🔤 Localized Values
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'library': 'Library',
      'profile': 'Profile',
      'downloads': 'Downloads',
      'favorites': 'Favorites',
      'earn': 'Earn',
      'audio': 'Audio',
      'continue': 'Continue',
      'skip': 'Skip',
      'error': 'Something went wrong',
    },
    'hi': {
      'library': 'लाइब्रेरी',
      'profile': 'प्रोफाइल',
      'downloads': 'डाउनलोड',
      'favorites': 'पसंदीदा',
      'earn': 'कमाई',
      'audio': 'ऑडियो',
      'continue': 'जारी रखें',
      'skip': 'छोड़ें',
      'error': 'कुछ गलत हो गया',
    },
    'gu': {
      'library': 'લાઇબ્રેરી',
      'profile': 'પ્રોફાઇલ',
      'downloads': 'ડાઉનલોડ',
      'favorites': 'ફેવરિટ',
      'earn': 'કમાણી',
      'audio': 'ઓડિયો',
      'continue': 'ચાલુ રાખો',
      'skip': 'સ્કિપ કરો',
      'error': 'કઈક ખોટું થયું',
    },
  };

  /// 🔑 Get String
  static String of(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;

    return _localizedValues[locale]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  /// 🔁 Safe Getter (No context needed)
  static String get(String key, {String locale = 'en'}) {
    return _localizedValues[locale]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }
}