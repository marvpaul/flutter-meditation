import 'package:flutter_meditation/settings/data/model/settings_model.dart';

abstract class SettingsRepository{
  static const String settingsKey = "settings";

  Future<SettingsModel?> getSettings();
  void saveSettings(SettingsModel settings);
  void restoreSettings();

}