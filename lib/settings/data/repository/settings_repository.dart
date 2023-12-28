import 'package:flutter_meditation/settings/data/model/settings_model.dart';

abstract class SettingsRepository{
  static const String settingsKey = "settings";

   List<String>? kaleidoscopeOptions = [
      'Arctic',
      'Aurora',
      'Circle',
      'City',
      'Golden',
      'Japan',
      'Metropolis',
      'Nature',
      'Plants',
      'Skyline'
    ];

    List<int>? meditationDurationOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  Future<SettingsModel> getSettings();
  void saveSettings(SettingsModel settings);
  void restoreSettings();

}