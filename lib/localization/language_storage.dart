import 'package:shared_preferences/shared_preferences.dart';

/// SchoolPro — centralized local storage for language preference.
/// Same pattern as Shopzo's AppStorage, kept separate from auth (UserViewModel)
/// so language survives logout/login of any role.
class LanguageStorage {
  LanguageStorage._();

  static const String _keyLanguageCode = 'language_code';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw StateError(
        'LanguageStorage not initialized. Call LanguageStorage.init() in main() before runApp().',
      );
    }
    return _prefs!;
  }

  static Future<void> saveLanguageCode(String code) =>
      _instance.setString(_keyLanguageCode, code);

  static String getLanguageCode() =>
      _instance.getString(_keyLanguageCode) ?? 'en';
}