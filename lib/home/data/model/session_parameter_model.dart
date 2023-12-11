import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'session_parameter_model.freezed.dart';
part 'session_parameter_model.g.dart';

@unfreezed
class SessionParameterModel with _$SessionParameterModel {
  factory SessionParameterModel({
    required String visualization,
    required int binauralFrequency,
    required double breathingMultiplier,
    required BreathingPatternType breathingPattern, 
    required Map<int, double> heartRates
  }) = _SessionParameterModel;



  factory SessionParameterModel.fromJson(Map<String, dynamic> json) =>
      _$SessionParameterModelFromJson(json);
}