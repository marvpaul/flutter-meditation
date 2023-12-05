import 'package:freezed_annotation/freezed_annotation.dart';
part 'breathing_pattern_model.freezed.dart';
part 'breathing_pattern_model.g.dart';

enum BreathingStepType {
  inhale,
  hold,
  exhale,
}

class BreathingPatternStep {
  final BreathingStepType type;
  final int duration;

  BreathingPatternStep({
    required this.type,
    required this.duration,
  });

  factory BreathingPatternStep.fromJson(Map<String, dynamic> json) {
    return BreathingPatternStep(
      type: BreathingStepType.values[json['type']],
      duration: json['duration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.index, // Assuming type is an enum
      'duration': duration,
    };
  }
}

@unfreezed
class BreathingPatternModel with _$BreathingPatternModel {
  factory BreathingPatternModel(
      {@Default('4-7-8') String name,
      @Default([]) List<BreathingPatternStep> steps,
      @Default(1.0) double multiplier}) = _BreathingPatternModel;

  factory BreathingPatternModel.fromJson(Map<String, dynamic> json) =>
      _$BreathingPatternModelFromJson(json);
}
