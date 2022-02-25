import 'dart:ui';

import 'package:crediApp/global/models/settings_model.dart';

Future<Settings> loadSettings() async {
  PreferenceService service = PreferenceService();
  return Settings(
    brightness: service.getThemeMode(),
    locale: service.getLocale(),
  );
}

class PreferenceService {
  Brightness getThemeMode() {
    return Brightness.light;
  }

  String getLocale() {
    return "ko";
  }
}
