import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meditation/di/Setup.dart';
import 'package:flutter_meditation/home/data/dto/meditation_dto.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_meditation/settings/data/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../meditation_repository.dart';

@singleton
class MeditationRepositoryLocal implements MeditationRepository {
  final SharedPreferences prefs;
  MeditationRepositoryLocal(this.prefs);

  @override
  Future<MeditationModel> getMeditation() async {
    print("TODO: Delete session for testing purposes");
    prefs.remove("session");
    final String? meditationObj =
        prefs.getString(MeditationRepository.sessionKey);
    if (meditationObj != null) {
      debugPrint(meditationObj);
      return MeditationDTO.fromJson(JsonDecoder().convert(meditationObj))
          .meditation;
    }
    MeditationModel meditationModel = MeditationModel(
        duration: 120,
        isHapticFeedbackEnabled: false,
        shouldShowHeartRate: false,
        sound: 'Option 1');
    saveMeditation(meditationModel);
    // return default if no config was found
    return meditationModel;
  }

  @override
  Future<MeditationModel> createNewMeditation() async {
    print("Create new meditation, fetch params from settings!");
    // TODO: Fetch duration
    SettingsRepository settingsRepository = getIt<SettingsRepositoryLocal>();
    SettingsModel? settings = await settingsRepository.getSettings();
    MeditationModel meditationModel = MeditationModel(
        duration: 120,
        isHapticFeedbackEnabled: settings?.isHapticFeedbackEnabled ?? false,
        shouldShowHeartRate: settings?.shouldShowHeartRate ?? false,
        sound: settings?.sound ?? 'Option 1');
    saveMeditation(meditationModel);
    // return default if no config was found
    return meditationModel;
  }

  @override
  void saveMeditation(MeditationModel meditationModel) {
    final String meditatonModelJSON = JsonEncoder()
        .convert(MeditationDTO(meditation: meditationModel).toJson());
    prefs.setString(MeditationRepository.sessionKey, meditatonModelJSON);
  }
  
  @override
  void restoreMeditation() {
    // TODO: implement restoreMeditation
  }
}
