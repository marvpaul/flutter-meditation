import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_breathing_patterns_model.freezed.dart';
part 'all_breathing_patterns_model.g.dart';

@freezed
class AllBreathingPatterns with _$AllBreathingPatterns {
  factory AllBreathingPatterns(
    Map<String, BreathingPatternModel> patternMap,
  ) = _AllBreathingPatterns;

  factory AllBreathingPatterns.fromJson(Map<String, dynamic> json) =>
      _$AllBreathingPatternsFromJson(json);
}
