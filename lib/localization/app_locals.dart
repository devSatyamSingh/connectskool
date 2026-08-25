import 'package:flutter/material.dart';
import 'lanaguge_model.dart';

class AppLocales {
  AppLocales._();

  static const Locale english = Locale('en');
  static const Locale hindi = Locale('hi');

  static const Locale defaultLocale = english;

  static const List<Locale> supported = [english, hindi];

  static const List<LanguageModel> languages = [
    LanguageModel(code: 'en', name: 'English', nativeName: 'English'),
    LanguageModel(code: 'hi', name: 'Hindi', nativeName: 'हिंदी'),
  ];
}