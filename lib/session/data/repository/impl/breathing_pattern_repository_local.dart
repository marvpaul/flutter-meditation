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
  Future<BreathingPatternModel> getBreathingPatternByName(BreathingPatternType type) async {
    AllBreathingPatterns patterns = await getOrCreateBreathingPatterns();
    return patterns.pattern.firstWhere((element) => element.type == type);
  }

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
        multiplier: 1.0);
    breathingPatternsList.add(fourSevenEight);

    // Coherent
    BreathingPatternModel coherent = BreathingPatternModel(
        type: BreathingPatternType.coherent,
        steps: [
          BreathingPatternStep(type: BreathingStepType.INHALE, duration: 0.5),
          BreathingPatternStep(type: BreathingStepType.EXHALE, duration: 0.5),
        ],
        multiplier: 1.0);
    breathingPatternsList.add(coherent);

    BreathingPatternModel box = BreathingPatternModel(
        type: BreathingPatternType.box,
        steps: [
          BreathingPatternStep(type: BreathingStepType.INHALE, duration: 4.0),
          BreathingPatternStep(type: BreathingStepType.HOLD, duration: 4.0),
          BreathingPatternStep(type: BreathingStepType.EXHALE, duration: 4.0),
          BreathingPatternStep(type: BreathingStepType.HOLD, duration: 4.0),
        ],
        multiplier: 1.0);
    breathingPatternsList.add(box);

    BreathingPatternModel twoToOne = BreathingPatternModel(
        type: BreathingPatternType.oneTwo,
        steps: [
          BreathingPatternStep(type: BreathingStepType.INHALE, duration: 4.0),
          BreathingPatternStep(type: BreathingStepType.EXHALE, duration: 8.0)
        ],
        multiplier: 1.0);
    breathingPatternsList.add(twoToOne);

    AllBreathingPatterns breathingPatterns =
        AllBreathingPatterns(breathingPatternsList);
    saveAllBreathingPatterns(breathingPatterns);
    return breathingPatterns;
  }

  @override
  void saveAllBreathingPatterns(AllBreathingPatterns allBreathingPatterns) {
    final String patternsJson = JsonEncoder().convert(
        AllBreathingPatternsDTO(allBreathingPatterns: allBreathingPatterns)
            .toJson());
    prefs.setString(
        BreathingPatternRepository.allBreathingPatternsKey, patternsJson);
  }
}
