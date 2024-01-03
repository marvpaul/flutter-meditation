import 'package:freezed_annotation/freezed_annotation.dart';
part 'breathing_pattern_model.freezed.dart';
part 'breathing_pattern_model.g.dart';

/// Enumeration representing different types of breathing steps.
///
/// The breathing steps include HOLD, INHALE, and EXHALE.
enum BreathingStepType {
  HOLD,
  INHALE,
  EXHALE,
}

/// Extension on [BreathingStepType] to provide human-readable values.
extension BreathingStateExtension on BreathingStepType {
  /// Get a human-readable string value for the enum.
  String get value {
    switch (this) {
      case BreathingStepType.HOLD:
        return 'Hold';
      case BreathingStepType.INHALE:
        return 'Inhale';
      case BreathingStepType.EXHALE:
        return 'Exhale';
    }
  }
}

/// Enumeration representing different types of breathing patterns.
///
/// The breathing patterns include fourSevenEight, coherent, box, and oneTwo.
enum BreathingPatternType {
  fourSevenEight,
  coherent,
  box,
  oneTwo,
}

/// Extension on [BreathingPatternType] to provide human-readable values.
extension BreathingTypeExtension on BreathingPatternType {
  /// Get a human-readable string value for the enum.
  String get value {
    switch (this) {
      case BreathingPatternType.fourSevenEight:
        return '4-7-8';
      case BreathingPatternType.coherent:
        return 'Coherent';
      case BreathingPatternType.box:
        return 'Box';
      case BreathingPatternType.oneTwo:
        return '1:2';
    }
  }
}

/// Class representing a single step in a breathing pattern.
///
/// Each step has a type (HOLD, INHALE, or EXHALE) and a duration.
class BreathingPatternStep {
  final BreathingStepType type;
  final double duration;

  /// Constructor for creating a [BreathingPatternStep] instance.
  BreathingPatternStep({
    required this.type,
    required this.duration,
  });

  /// Factory method to create a [BreathingPatternStep] from JSON data.
  factory BreathingPatternStep.fromJson(Map<String, dynamic> json) {
    return BreathingPatternStep(
      type: BreathingStepType.values[json['type']],
      duration: json['duration'] as double,
    );
  }

  /// Convert the [BreathingPatternStep] to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'type': type.index, // Assuming type is an enum
      'duration': duration,
    };
  }
}

/// Freezed class representing a breathing pattern model.
///
/// This class is annotated with @freezed, allowing the use of freezed code
/// generation to create boilerplate code for immutable classes.
///
/// The class represents a breathing pattern, including its type, steps,
/// and multiplier. We generate 4 of those on first app start and persist them in the local storage.
@freezed
class BreathingPatternModel with _$BreathingPatternModel {
  /// Default constructor for creating an instance of [BreathingPatternModel].
  ///
  /// The constructor allows specifying the type, steps, and multiplier
  /// for a breathing pattern.
  factory BreathingPatternModel({
    @Default(BreathingPatternType.fourSevenEight) BreathingPatternType type,
    @Default([]) List<BreathingPatternStep> steps,
    @Default(1.0) double multiplier,
  }) = _BreathingPatternModel;

  /// Factory method to create a [BreathingPatternModel] from JSON data.
  ///
  /// This method is used to deserialize a JSON object into an instance of
  /// [BreathingPatternModel]. It takes a Map<String, dynamic> as input.
  factory BreathingPatternModel.fromJson(Map<String, dynamic> json) =>
      _$BreathingPatternModelFromJson(json);
}
