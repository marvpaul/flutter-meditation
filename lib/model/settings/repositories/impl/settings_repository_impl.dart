import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_meditation/model/settings/settings_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/settings/DTO/settings_dto.dart';
import '../settings_repository.dart';


@singleton
class SettingsRepositoryImpl implements ISettingsRepository{
  final SharedPreferences prefs;

  SettingsRepositoryImpl(this.prefs);

  @override
  Future<SettingsModel> getSettings() async {
    final String? settingsJson = prefs.getString("settings");
    if (settingsJson != null) {
      debugPrint(settingsJson);
      return SettingsDTO.fromJson(JsonDecoder().convert(settingsJson)).settings;
    }
    // return default if no config was found
    return SettingsModel();
  }

  void saveSettings() {
    // TODO: implement saveSettings
  }
}