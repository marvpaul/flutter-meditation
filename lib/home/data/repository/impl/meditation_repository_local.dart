/// {@category Repository}
/// A local implementation of the [MeditationRepository] interface which helds data about our actual meditation session in the local storage.
library meditation_repository_local;

import 'dart:convert';
import 'package:flutter_meditation/di/Setup.dart';
import 'package:flutter_meditation/home/data/dto/meditation_dto.dart';
import 'package:flutter_meditation/home/data/model/heartrate_measurement_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/model/session_parameter_model.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:flutter_meditation/session/data/repository/breathing_pattern_repository.dart';
import 'package:flutter_meditation/session/data/repository/impl/breathing_pattern_repository_local.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_meditation/settings/data/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../meditation_repository.dart';

/// A local implementation of the [MeditationRepository] interface which helds data about our actual meditation session in the local storage.
@singleton
class MeditationRepositoryLocal implements MeditationRepository {
  final SharedPreferences prefs;
  MeditationRepositoryLocal(this.prefs);

  /// Creates a new meditation based on settings and returns the created [MeditationModel].
  ///
  /// The duration and other parameters are fetched from the settings and breathing pattern.
  @override
  Future<MeditationModel> createNewMeditation({ bool showKaleidoscope = false }) async {
    print("Create new meditation, fetch params from settings! showKaleidoscope: $showKaleidoscope");
    // TODO: Fetch duration
    SettingsRepository settingsRepository = getIt<SettingsRepositoryLocal>();
    BreathingPatternRepository breathingPatternRepository =
        getIt<BreathingPatternRepositoryLocal>();
    SettingsModel? settings = await settingsRepository.getSettings();
    BreathingPatternModel pattern = await breathingPatternRepository
        .getBreathingPatternByName(settings.breathingPattern);
    MeditationModel meditationModel = MeditationModel(
        duration: settings.meditationDuration * 60,
        isHapticFeedbackEnabled: settings.isHapticFeedbackEnabled,
        shouldShowHeartRate: settings.shouldShowHeartRate,
        timestamp: DateTime.now().millisecondsSinceEpoch / 1000.0,
        sessionParameters: [
          SessionParameterModel(
              visualization:
                  settings.kaleidoscope || showKaleidoscope ? settings.kaleidoscopeImage : null,
              // TODO: either get an optimized frequency from the trained model or use a default value
              binauralFrequency: settings.binauralBeatFrequency,
              breathingMultiplier: pattern.multiplier,
              breathingPattern: settings.breathingPattern,
              heartRates: [])
        ],
        completedSession: false);
    saveMeditation(meditationModel);
    // return default if no config was found
    return meditationModel;
  }

  /// Saves the provided [meditationModel] to local storage.
  @override
  void saveMeditation(MeditationModel meditationModel) {
    final String meditatonModelJSON = JsonEncoder()
        .convert(MeditationDTO(meditation: meditationModel).toJson());
    prefs.setString(MeditationRepository.sessionKey, meditatonModelJSON);
  }

  @override
  double getAverageHeartRate(MeditationModel model) {
    List<HeartrateMeasurementModel> heartRates = [];
    model.sessionParameters.forEach((element) {
      heartRates.addAll(element.heartRates);
    });
    if (heartRates.isEmpty) {
      return 0.0; // Return 0 if the map is empty to avoid division by zero
    }

    // Calculate the sum of all values
    dynamic sum = 0;
    heartRates.forEach((value) {
      sum += value.heartRate;
    });

    // Calculate the average
    double average = sum / heartRates.length;

    return double.parse(average.toStringAsFixed(1));
  }

  @override
  double getMinHeartRate(MeditationModel model) {
    List<HeartrateMeasurementModel> heartRates = [];
    model.sessionParameters.forEach((element) {
      heartRates.addAll(element.heartRates);
    });
    if (heartRates.isEmpty) {
      return 0.0; // Return 0 if the map is empty to avoid division by zero
    }

    // Calculate the sum of all values
    dynamic min = 1000;
    heartRates.forEach((value) {
      if (min > value.heartRate) {
        min = value.heartRate;
      }
    });
    return double.parse(min.toStringAsFixed(1));
  }

  @override
  double getMaxHeartRate(MeditationModel model) {
    List<HeartrateMeasurementModel> heartRates = [];
    model.sessionParameters.forEach((element) {
      heartRates.addAll(element.heartRates);
    });
    if (heartRates.isEmpty) {
      return 0.0; // Return 0 if the map is empty to avoid division by zero
    }

    // Calculate the sum of all values
    double max = 0;
    heartRates.forEach((value) {
      if (max < value.heartRate) {
        max = value.heartRate;
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
          heartRates: [
            HeartrateMeasurementModel(
                timestamp: timestamp, heartRate: heartRate)
          ]));
    } else {
      model.sessionParameters[model.sessionParameters.length - 1].heartRates
          .add(HeartrateMeasurementModel(
              timestamp: timestamp, heartRate: heartRate));
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
        heartRates: []);
  }

  @override
  void restoreMeditation() {
    // TODO: implement restoreMeditation
  }
}
