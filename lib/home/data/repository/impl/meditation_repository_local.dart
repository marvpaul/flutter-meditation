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
        sound: 'Option 1',
        timestamp: DateTime.now().millisecondsSinceEpoch / 1000.0,
        heartRates: {});
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
        sound: settings?.sound ?? 'Option 1',
        timestamp: DateTime.now().millisecondsSinceEpoch / 1000.0,
        heartRates: {});
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
    Map<int, dynamic> heartRates = model.heartRates;
    if (heartRates.isEmpty) {
      return 0.0; // Return 0 if the map is empty to avoid division by zero
    }

    // Calculate the sum of all values
    dynamic sum = 0;
    heartRates.values.forEach((value) {
      if (value is num) {
        sum += value;
      }
    });

    // Calculate the average
    double average = sum / heartRates.length;

    return double.parse(average.toStringAsFixed(1)); 
  }
  @override
  double getMinHeartRate(MeditationModel model) {
    Map<int, dynamic> heartRates = model.heartRates;
    if (heartRates.isEmpty) {
      return 0.0; // Return 0 if the map is empty to avoid division by zero
    }

    // Calculate the sum of all values
    dynamic min = 1000;
    heartRates.values.forEach((value) {
      if (value is num) {
        if(min > value){
          min = value; 
        }
      }
    });
    return double.parse(min.toStringAsFixed(1)); 
  }
  @override
  double getMaxHeartRate(MeditationModel model) {
    Map<int, dynamic> heartRates = model.heartRates;
    if (heartRates.isEmpty) {
      return 0.0; // Return 0 if the map is empty to avoid division by zero
    }

    // Calculate the sum of all values
    double max = 0;
    heartRates.values.forEach((value) {
      if (value is double) {
        if(max < value){
          max = value; 
        }
      }
    });
    return double.parse(max.toStringAsFixed(1)); 
  }

  @override
  void restoreMeditation() {
    // TODO: implement restoreMeditation
  }
}
