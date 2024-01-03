import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_meditation/session/data/dto/all_breathing_patterns_dto.dart';
import 'package:flutter_meditation/session/data/model/all_breathing_patterns_model.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:flutter_meditation/session/data/repository/breathing_pattern_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local implementation of [BreathingPatternRepository] using shared preferences.
@singleton
class BreathingPatternRepositoryLocal implements BreathingPatternRepository {
  final SharedPreferences prefs;

  /// Constructor that takes [SharedPreferences] as a dependency.
  BreathingPatternRepositoryLocal(this.prefs);

  /// Retrieves the breathing pattern with the specified [type].
  ///
  /// Returns a [BreathingPatternModel] matching the given [type].
  @override
  Future<BreathingPatternModel> getBreathingPatternByName(
    BreathingPatternType type,
  ) async {
    AllBreathingPatterns patterns = await getOrCreateBreathingPatterns();
    return patterns.pattern.firstWhere((element) => element.type == type);
  }

  /// Retrieves or creates all available breathing patterns.
  /// We create the breathing patterns on first startup and save them. 
  /// When the users starts the application again, we just fetch from the shared preferences.
  ///
  /// Returns an [AllBreathingPatterns] instance containing a list of all breathing patterns.
  @override
  Future<AllBreathingPatterns> getOrCreateBreathingPatterns() async {
    final String? allBreathingPatternsJson =
        prefs.getString(BreathingPatternRepository.allBreathingPatternsKey);
    if (allBreathingPatternsJson != null) {
      debugPrint(allBreathingPatternsJson);
      return AllBreathingPatternsDTO.fromJson(
              JsonDecoder().convert(allBreathingPatternsJson))
          .allBreathingPatterns;
    }

    List<BreathingPatternModel> breathingPatternsList = [];

    // 4-7-8
    BreathingPatternModel fourSevenEight = BreathingPatternModel(
      type: BreathingPatternType.fourSevenEight,
      steps: [
        BreathingPatternStep(type: BreathingStepType.INHALE, duration: 4),
        BreathingPatternStep(type: BreathingStepType.HOLD, duration: 7),
        BreathingPatternStep(type: BreathingStepType.EXHALE, duration: 8),
      ],
      multiplier: 1.0,
    );
    breathingPatternsList.add(fourSevenEight);

    // Coherent
    BreathingPatternModel coherent = BreathingPatternModel(
      type: BreathingPatternType.coherent,
      steps: [
        BreathingPatternStep(type: BreathingStepType.INHALE, duration: 0.5),
        BreathingPatternStep(type: BreathingStepType.EXHALE, duration: 0.5),
      ],
      multiplier: 1.0,
    );
    breathingPatternsList.add(coherent);

    // Box
    BreathingPatternModel box = BreathingPatternModel(
      type: BreathingPatternType.box,
      steps: [
        BreathingPatternStep(type: BreathingStepType.INHALE, duration: 4.0),
        BreathingPatternStep(type: BreathingStepType.HOLD, duration: 4.0),
        BreathingPatternStep(type: BreathingStepType.EXHALE, duration: 4.0),
        BreathingPatternStep(type: BreathingStepType.HOLD, duration: 4.0),
      ],
      multiplier: 1.0,
    );
    breathingPatternsList.add(box);

    // 1:2
    BreathingPatternModel twoToOne = BreathingPatternModel(
      type: BreathingPatternType.oneTwo,
      steps: [
        BreathingPatternStep(type: BreathingStepType.INHALE, duration: 4.0),
        BreathingPatternStep(type: BreathingStepType.EXHALE, duration: 8.0),
      ],
      multiplier: 1.0,
    );
    breathingPatternsList.add(twoToOne);

    AllBreathingPatterns breathingPatterns =
        AllBreathingPatterns(breathingPatternsList);
    saveAllBreathingPatterns(breathingPatterns);
    return breathingPatterns;
  }

  /// Saves the provided [allBreathingPatterns] to shared preferences.
  ///
  /// This method serializes the provided [AllBreathingPatterns] instance
  /// into JSON and stores it in shared preferences.
  @override
  void saveAllBreathingPatterns(AllBreathingPatterns allBreathingPatterns) {
    final String patternsJson = JsonEncoder().convert(
      AllBreathingPatternsDTO(
        allBreathingPatterns: allBreathingPatterns,
      ).toJson(),
    );
    prefs.setString(
      BreathingPatternRepository.allBreathingPatternsKey,
      patternsJson,
    );
  }
}
