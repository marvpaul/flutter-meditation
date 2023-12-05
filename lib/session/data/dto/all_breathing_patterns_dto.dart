import 'package:flutter_meditation/session/data/model/all_breathing_patterns_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'all_breathing_patterns_dto.freezed.dart';
part 'all_breathing_patterns_dto.g.dart';
@unfreezed
class AllBreathingPatternsDTO with _$AllBreathingPatternsDTO {
  factory AllBreathingPatternsDTO({
    required final AllBreathingPatterns allBreathingPatterns,        // it's also possible to return a list of settings here
  }) = _AllBreathingPatternsDTO;

  factory AllBreathingPatternsDTO.fromJson(Map<String, dynamic> json) =>
      _$AllBreathingPatternsDTOFromJson(json);
}