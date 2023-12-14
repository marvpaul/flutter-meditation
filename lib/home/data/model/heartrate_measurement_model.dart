import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'heartrate_measurement_model.freezed.dart';
part 'heartrate_measurement_model.g.dart';

@unfreezed
class HeartrateMeasurementModel with _$HeartrateMeasurementModel {
  factory HeartrateMeasurementModel({
    required int timestamp,
    required double heartRate,
  }) = _HeartrateMeasurementModel;

  factory HeartrateMeasurementModel.fromJson(Map<String, dynamic> json) =>
      _$HeartrateMeasurementModelFromJson(json);
}
