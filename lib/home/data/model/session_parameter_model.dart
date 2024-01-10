/// {@category Model}
/// Represents a model for storing session parameters, including visualization,
/// binaural frequency, breathing multiplier, breathing pattern, and heart rates.
library session_parameter_model;
import 'package:flutter_meditation/home/data/model/heartrate_measurement_model.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'session_parameter_model.freezed.dart';
part 'session_parameter_model.g.dart';

@unfreezed
class SessionParameterModel with _$SessionParameterModel {
  /// Creates a [SessionParameterModel].
  factory SessionParameterModel({
    /// The visualization / kaleidoscope used during the session.
    String? visualization,

    /// The binaural frequency used during the session.
    int? binauralFrequency,

    /// The multiplier for the breathing pattern during the session.
    required double breathingMultiplier,

    /// The breathing pattern used during the session.
    required BreathingPatternType breathingPattern,

    /// The list of heart rate measurements recorded during the session.
    required List<HeartrateMeasurementModel> heartRates,
  }) = _SessionParameterModel;

  /// Creates a [SessionParameterModel] from a JSON map.
  factory SessionParameterModel.fromJson(Map<String, dynamic> json) =>
      _$SessionParameterModelFromJson(json);
}
