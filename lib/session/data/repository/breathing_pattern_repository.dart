import 'package:flutter_meditation/session/data/model/all_breathing_patterns_model.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';

abstract class BreathingPatternRepository {
  static const String allBreathingPatternsKey = "breathings";
  Future<AllBreathingPatterns> getOrCreateBreathingPatterns();
  Future<BreathingPatternModel> getBreathingPatternByName(BreathingPatternType name);
  void saveAllBreathingPatterns(AllBreathingPatterns patterns);
}
