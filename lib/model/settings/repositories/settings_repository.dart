import 'package:flutter_meditation/model/settings/settings_model.dart';

abstract class ISettingsRepository{
  Future<SettingsModel?> getSettings();
}