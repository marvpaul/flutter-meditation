import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'breathing_pattern_dto.freezed.dart';
part 'breathing_pattern_dto.g.dart';
@unfreezed
class BreathingPatternDTO with _$BreathingPatternDTO {
  factory BreathingPatternDTO({
    required final BreathingPatternModel breathingPatternModel,        // it's also possible to return a list of settings here
  }) = _BreathingPatternDTO;

  factory BreathingPatternDTO.fromJson(Map<String, dynamic> json) =>
      _$BreathingPatternDTOFromJson(json);
}