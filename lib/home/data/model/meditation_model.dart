import 'package:freezed_annotation/freezed_annotation.dart';
part 'meditation_model.freezed.dart';
part 'meditation_model.g.dart';

@unfreezed
class MeditationModel with _$MeditationModel {
  factory MeditationModel({
    required int duration,
    required bool isHapticFeedbackEnabled,
    required bool shouldShowHeartRate,
    required String sound,
  }) = _MeditationModel;

  factory MeditationModel.fromJson(Map<String, dynamic> json) =>
      _$MeditationModelFromJson(json);
}