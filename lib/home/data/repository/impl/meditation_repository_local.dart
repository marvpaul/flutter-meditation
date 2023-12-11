import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meditation/di/Setup.dart';
import 'package:flutter_meditation/home/data/dto/meditation_dto.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/model/session_parameter_model.dart';
import 'package:flutter_meditation/session/data/model/all_breathing_patterns_model.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:flutter_meditation/session/data/repository/breathing_pattern_repository.dart';
import 'package:flutter_meditation/session/data/repository/impl/breathing_pattern_repository_local.dart';
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
    final String? meditationObj =
        prefs.getString(MeditationRepository.sessionKey);
    if (meditationObj != null) {
      debugPrint(meditationObj);
      return MeditationDTO.fromJson(JsonDecoder().convert(meditationObj))
          .meditation;
    }
    MeditationModel meditationModel = MeditationModel(
        duration: 20,
        isHapticFeedbackEnabled: false,
        shouldShowHeartRate: false,
        sound: 'Option 1',
        timestamp: DateTime.now().millisecondsSinceEpoch / 1000.0,
        sessionParameters: []);
    saveMeditation(meditationModel);
    // return default if no config was found
    return meditationModel;
  }

  @override
  Future<MeditationModel> createNewMeditation() async {
    print("Create new meditation, fetch params from settings!");
    // TODO: Fetch duration
    SettingsRepository settingsRepository = getIt<SettingsRepositoryLocal>();
    BreathingPatternRepository breathingPatternRepository = getIt<BreathingPatternRepositoryLocal>();
    SettingsModel? settings = await settingsRepository.getSettings();
    BreathingPatternModel pattern = await breathingPatternRepository.getBreathingPatternByName(settings.breathingPattern);
    MeditationModel meditationModel = MeditationModel(
        duration: 120,
        isHapticFeedbackEnabled: settings?.isHapticFeedbackEnabled ?? false,
        shouldShowHeartRate: settings?.shouldShowHeartRate ?? false,
        sound: settings?.sound ?? 'Option 1',
        timestamp: DateTime.now().millisecondsSinceEpoch / 1000.0,
        sessionParameters: [
          SessionParameterModel(
              visualization: settings.kaleidoscopeImage,
              binauralFrequency: settings.binauralBeatFrequency,
              breathingMultiplier: pattern.multiplier,
              breathingPattern: settings.breathingPattern,
              heartRates: {})
        ]);
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
  double getAverageHeartRate(MeditationModel model) {
    Map<int, double> heartRates = {};
    model.sessionParameters.forEach((element) {
      heartRates.addAll(element.heartRates);
    });
    if (heartRates.isEmpty) {
      return 0.0; // Return 0 if the map is empty to avoid division by zero
    }

    // Calculate the sum of all values
    dynamic sum = 0;
    heartRates.values.forEach((value) {
      sum += value;
    });

    // Calculate the average
    double average = sum / heartRates.length;

    return double.parse(average.toStringAsFixed(1));
  }

  @override
  double getMinHeartRate(MeditationModel model) {
    Map<int, double> heartRates = {};
    model.sessionParameters.forEach((element) {
      heartRates.addAll(element.heartRates);
    });
    if (heartRates.isEmpty) {
      return 0.0; // Return 0 if the map is empty to avoid division by zero
    }

    // Calculate the sum of all values
    dynamic min = 1000;
    heartRates.values.forEach((value) {
      if (min > value) {
        min = value;
      }
    });
    return double.parse(min.toStringAsFixed(1));
  }

  @override
  double getMaxHeartRate(MeditationModel model) {
    Map<int, double> heartRates = {};
    model.sessionParameters.forEach((element) {
      heartRates.addAll(element.heartRates);
    });
    if (heartRates.isEmpty) {
      return 0.0; // Return 0 if the map is empty to avoid division by zero
    }

    // Calculate the sum of all values
    double max = 0;
    heartRates.values.forEach((value) {
      if (max < value) {
        max = value;
      }
    });
    return double.parse(max.toStringAsFixed(1));
  }

  @override
  void addHeartRate(MeditationModel model, int timestamp, double heartRate) {
    if (model.sessionParameters.isEmpty) {
      model.sessionParameters.add(SessionParameterModel(
          visualization: "Arctic",
          binauralFrequency: 30,
          breathingMultiplier: 1.0,
          breathingPattern: BreathingPatternType.fourSevenEight,
          heartRates: {timestamp: heartRate}));
    } else {
      model.sessionParameters[model.sessionParameters.length - 1]
          .heartRates[timestamp] = heartRate;
    }
  }

  @override
  SessionParameterModel getLatestSessionParamaters(MeditationModel model) {
    if (!model.sessionParameters.isEmpty) {
      return model.sessionParameters[model.sessionParameters.length - 1];
    }
    return SessionParameterModel(
        visualization: 'Arctic',
        binauralFrequency: 30,
        breathingMultiplier: 1.0,
        breathingPattern: BreathingPatternType.fourSevenEight,
        heartRates: {});
  }

  @override
  void restoreMeditation() {
    // TODO: implement restoreMeditation
  }
}
