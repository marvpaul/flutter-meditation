/// {@category Model}
/// Represent parameters for a meditation session. Here we store information like the duration of a meditation session and 
/// a List of [SessionParameterModel] which contains our meditation session parameters and all measured heart rates
library meditation_model;
import 'package:flutter_meditation/home/data/model/session_parameter_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'meditation_model.freezed.dart';
part 'meditation_model.g.dart';

@unfreezed
class MeditationModel with _$MeditationModel {
  factory MeditationModel({
    required int duration,
    required bool isHapticFeedbackEnabled,
    required bool shouldShowHeartRate,
    required double timestamp, // TODO: should be an int
    required List<SessionParameterModel> sessionParameters,
    required bool completedSession
  }) = _MeditationModel;



  factory MeditationModel.fromJson(Map<String, dynamic> json) =>
      _$MeditationModelFromJson(json);
}