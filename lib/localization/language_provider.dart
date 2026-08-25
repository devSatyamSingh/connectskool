import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'app_locals.dart';
import 'lanaguge_model.dart';
import 'language_storage.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = Locale(LanguageStorage.getLanguageCode());

  Locale get locale => _locale;

  Future<void> changeLanguage(BuildContext context, Locale newLocale) async {
    if (_locale == newLocale) return;

    await context.setLocale(newLocale);
    await LanguageStorage.saveLanguageCode(newLocale.languageCode);

    _locale = newLocale;
    notifyListeners();
  }

  LanguageModel get currentLanguageModel => AppLocales.languages.firstWhere(
        (l) => l.code == _locale.languageCode,
    orElse: () => AppLocales.languages.first,
  );
}