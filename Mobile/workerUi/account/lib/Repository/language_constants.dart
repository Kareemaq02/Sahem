// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// // ignore_for_file: constant_identifier_names


// const String LAGUAGE_CODE = 'languageCode';

// //languages code
// const String ENGLISH = 'en';
// const String ARABIC = 'ar';


// Future<Locale> setLocale(String languageCode) async {
//   SharedPreferences _prefs = await SharedPreferences.getInstance();
//   await _prefs.setString(LAGUAGE_CODE, languageCode);
//   return _locale(languageCode);
// }

// Future<Locale> getLocale() async {
//   SharedPreferences _prefs = await SharedPreferences.getInstance();
//   String languageCode = _prefs.getString(LAGUAGE_CODE) ?? ENGLISH;
//   return _locale(languageCode);
// }

// Locale _locale(String languageCode) {
//   switch (languageCode) {
//     case ENGLISH:
//       return const Locale(ENGLISH, '');
//     case ARABIC:
//       return const Locale(ARABIC, "");
    
//     default:
//       return const Locale(ENGLISH, '');
//   }
// }

// AppLocalizations translation(BuildContext context) {
//   return AppLocalizations.of(context)!;
// }