/// {@category Model}
/// A model which contains a list of all available [BreathingPatternModel]
library all_breathing_patterns_model; 

import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'all_breathing_patterns_model.freezed.dart';
part 'all_breathing_patterns_model.g.dart';

/// Freezed class representing a collection of breathing patterns.
///
/// This class is annotated with @freezed, allowing the use of freezed code
/// generation to create boilerplate code for immutable classes.
///
/// The class represents a collection of [BreathingPatternModel] instances.
/// Instances of this class are used to hold a list of breathing patterns.
/// It is part of the meditation session data model.
@freezed
class AllBreathingPatterns with _$AllBreathingPatterns {
  /// Default constructor for creating an instance of [AllBreathingPatterns].
  ///
  /// The constructor takes a list of [BreathingPatternModel] instances.
  factory AllBreathingPatterns(
    List<BreathingPatternModel> patterns,
  ) = _AllBreathingPatterns;

  /// Factory method to create an instance of [AllBreathingPatterns] from JSON data.
  ///
  /// This method is used to deserialize a JSON object into an instance of
  /// [AllBreathingPatterns]. It takes a Map<String, dynamic> as input.
  factory AllBreathingPatterns.fromJson(Map<String, dynamic> json) =>
      _$AllBreathingPatternsFromJson(json);
}
