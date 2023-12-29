import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prediction_request_model.freezed.dart';

part 'prediction_request_model.g.dart';

@freezed
class PredictionRequestModel with _$PredictionRequestModel {
  factory PredictionRequestModel(
      @JsonKey(name: 'heart_rate_arr')
      List<int> heartRates,
      @JsonKey(name: 'binaural_beats_arr')
      List<int> binauralBeats,
      @JsonKey(name: 'visualization_arr')
      List<int> visualizations,
      @JsonKey(name: 'breath_multiplier_arr')
      List<double> breathingMultipliers,
      @JsonKey(name: 'user_id')
      String userId) = _PredictionRequestModel;

  factory PredictionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PredictionRequestModelFromJson(json);
}
