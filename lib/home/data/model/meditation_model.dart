import 'package:freezed_annotation/freezed_annotation.dart';
part 'meditation_model.freezed.dart';
part 'meditation_model.g.dart';

@unfreezed
class MeditationModel with _$MeditationModel {
  factory MeditationModel({
    required int duration,
  }) = _MeditationModel;

  factory MeditationModel.fromJson(Map<String, dynamic> json) =>
      _$MeditationModelFromJson(json);
}