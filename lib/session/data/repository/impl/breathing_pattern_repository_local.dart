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
  Future<BreathingPatternModel> getBreathingPatternByName(String name) async {
    // TODO: implement getBreathingPatternByName
    AllBreathingPatterns patterns = await getOrCreateBreathingPatterns();
    return patterns.patternMap[name]!;  
  }

  @override
  Future<AllBreathingPatterns> getOrCreateBreathingPatterns() async {
    prefs.clear(); 
    // Get from local storage
    final String? allBreathingPatternsJson =
        prefs.getString(BreathingPatternRepository.allBreathingPatternsKey);
    if (allBreathingPatternsJson != null) {
      debugPrint(allBreathingPatternsJson);
      return AllBreathingPatternsDTO.fromJson(
              JsonDecoder().convert(allBreathingPatternsJson))
          .allBreathingPatterns;
    }
    
    Map<String, BreathingPatternModel> breathingPatternsMap = <String, BreathingPatternModel>{};
    print("Create new breathings!"); 

    // 4-7-8
    BreathingPatternModel fourSevenEight = BreathingPatternModel(
        name: "4-7-8",
        steps: [
          BreathingPatternStep(type: BreathingStepType.INHALE, duration: 4),
          BreathingPatternStep(type: BreathingStepType.HOLD, duration: 7),
          BreathingPatternStep(type: BreathingStepType.EXHALE, duration: 8),
        ],
        multiplier: 1.0);
    breathingPatternsMap["4-7-8"] = fourSevenEight; 

    // Coherent 
    BreathingPatternModel coherent = BreathingPatternModel(
        name: "Coherent",
        steps: [
          BreathingPatternStep(type: BreathingStepType.INHALE, duration: 0.5),
          BreathingPatternStep(type: BreathingStepType.EXHALE, duration: 0.5),
        ],
        multiplier: 1.0);
    breathingPatternsMap["Coherent"] = coherent; 

    BreathingPatternModel box = BreathingPatternModel(
        name: "Box",
        steps: [
          BreathingPatternStep(type: BreathingStepType.INHALE, duration: 4.0),
          BreathingPatternStep(type: BreathingStepType.HOLD, duration: 4.0),
          BreathingPatternStep(type: BreathingStepType.EXHALE, duration: 4.0),
          BreathingPatternStep(type: BreathingStepType.HOLD, duration: 4.0),
        ],
        multiplier: 1.0);
    breathingPatternsMap["Box"] = box; 

    BreathingPatternModel twoToOne = BreathingPatternModel(
        name: "1:2",
        steps: [
          BreathingPatternStep(type: BreathingStepType.INHALE, duration: 4.0),
          BreathingPatternStep(type: BreathingStepType.EXHALE, duration: 8.0)
        ],
        multiplier: 1.0);
    breathingPatternsMap["1:2"] = twoToOne; 

    AllBreathingPatterns breathingPatterns = AllBreathingPatterns(breathingPatternsMap);
    saveAllBreathingPatterns(breathingPatterns);
    return breathingPatterns;
  }

  @override
  void saveAllBreathingPatterns(AllBreathingPatterns allBreathingPatterns) {
    final String patternsJson = JsonEncoder().convert(AllBreathingPatternsDTO(allBreathingPatterns: allBreathingPatterns).toJson());
    prefs.setString(BreathingPatternRepository.allBreathingPatternsKey, patternsJson);
  }
}
