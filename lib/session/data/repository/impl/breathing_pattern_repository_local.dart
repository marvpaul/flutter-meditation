import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meditation/session/data/dto/all_breathing_patterns_dto.dart';
import 'package:flutter_meditation/session/data/model/all_breathing_patterns_model.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:flutter_meditation/session/data/repository/breathing_pattern_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class BreathingPatternRepositoryLocal implements BreathingPatternRepository {
  final SharedPreferences prefs;
  BreathingPatternRepositoryLocal(this.prefs);

  @override
  Future<BreathingPatternModel> getBreathingPatternByName(String name) {
    // TODO: implement getBreathingPatternByName
    throw UnimplementedError();
  }

  @override
  Future<AllBreathingPatterns> getOrCreateBreathingPatterns() async {
    // Get from local storage
    final String? allBreathingPatternsJson =
        prefs.getString(BreathingPatternRepository.allBreathingPatternsKey);
    if (allBreathingPatternsJson != null) {
      debugPrint(allBreathingPatternsJson);
      return AllBreathingPatternsDTO.fromJson(
              JsonDecoder().convert(allBreathingPatternsJson))
          .allBreathingPatterns;
    }

    // Create all
    AllBreathingPatterns breathingPatterns = AllBreathingPatterns();
    BreathingPatternModel fourSevenEight = BreathingPatternModel(
        name: "4-7-8",
        steps: [
          BreathingPatternStep(type: BreathingStepType.inhale, duration: 4),
          BreathingPatternStep(type: BreathingStepType.hold, duration: 7),
          BreathingPatternStep(type: BreathingStepType.exhale, duration: 8),
        ],
        multiplier: 1.0);

    print("Create new breathings!"); 
    breathingPatterns.patternMap["4-7-8"] = fourSevenEight; 
    saveAllBreathingPatterns(breathingPatterns);
    // return default if no config was found
    return breathingPatterns;
  }

  @override
  void saveAllBreathingPatterns(AllBreathingPatterns allBreathingPatterns) {
    final String patternsJson = JsonEncoder().convert(AllBreathingPatternsDTO(allBreathingPatterns: allBreathingPatterns).toJson());
    print("Save all breathings"); 
    print("JSON" + patternsJson); 
    prefs.setString(BreathingPatternRepository.allBreathingPatternsKey, patternsJson);
  }
}
