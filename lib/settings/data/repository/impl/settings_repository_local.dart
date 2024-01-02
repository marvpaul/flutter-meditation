import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';


import '../../dto/settings_dto.dart';
import '../settings_repository.dart';


@singleton
class SettingsRepositoryLocal implements SettingsRepository {
  final SharedPreferences prefs;
  SettingsRepositoryLocal(this.prefs);

   @override
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

    @override
      List<int>? meditationDurationOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  Future<SettingsModel> getSettings() async {
    final String? settingsJson = prefs.getString(SettingsRepository.settingsKey);
    if (settingsJson != null) {
      debugPrint(settingsJson);
      return SettingsDTO.fromJson(JsonDecoder().convert(settingsJson)).settings;
    }
    SettingsModel settingsModel = SettingsModel(uuid: _generateUUID());
    saveSettings(settingsModel);
    // return default if no config was found
    return settingsModel;
  }

  @override
  void saveSettings(SettingsModel settings) {
    final String settingsJson = JsonEncoder().convert(SettingsDTO(settings: settings).toJson());
    prefs.setString(SettingsRepository.settingsKey, settingsJson);
  }

  @override
  void restoreSettings() {
    saveSettings(SettingsModel(uuid: _generateUUID()));
  }

  String _generateUUID(){
    Uuid uuid = Uuid();
    return uuid.v4();
  }

  @override
  Future<String> getDeviceId() async {
    SettingsModel settings = await getSettings();
    return settings.uuid;
  }
}