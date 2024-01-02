import 'package:freezed_annotation/freezed_annotation.dart';

part 'past_sessions_response_dto.freezed.dart';
part 'past_sessions_response_dto.g.dart';

@freezed
class PastSessionsResponseDTO with _$PastSessionsResponseDTO {
  factory PastSessionsResponseDTO({
    List<PastSessionDTO>? meditationSessions,
    String? message,
  }) = _PastSessionsResponseDTO;

  factory PastSessionsResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$PastSessionsResponseDTOFromJson(json);
}

@freezed
class PastSessionDTO with _$PastSessionDTO {
  factory PastSessionDTO({
    required String date,
    required String deviceId,
    required int duration,
    required bool isCanceled,
    required bool isCompleted,
    required List<SessionPeriodDTO> sessionPeriods,
  }) = _PastSessionDTO;

  factory PastSessionDTO.fromJson(Map<String, dynamic> json) =>
      _$PastSessionDTOFromJson(json);
}


@freezed
class SessionPeriodDTO with _$SessionPeriodDTO {
  factory SessionPeriodDTO({
    required double beatFrequency,
    required List<BreathingPatternDTO> breathingPattern,
    required double breathingPatternMultiplier,
    required List<HeartRateMeasurementDTO> heartRateMeasurements,
    required bool isHapticFeedbackEnabled,
    required String visualization,
  }) = _SessionPeriodDTO;

  factory SessionPeriodDTO.fromJson(Map<String, dynamic> json) =>
      _$SessionPeriodDTOFromJson(json);
}


@freezed
class BreathingPatternDTO with _$BreathingPatternDTO {
  factory BreathingPatternDTO({
    int? inhale,
    int? hold,
    int? exhale,
  }) = _BreathingPatternDTO;

  factory BreathingPatternDTO.fromJson(Map<String, dynamic> json) =>
      _$BreathingPatternDTOFromJson(json);
}

@freezed
class HeartRateMeasurementDTO with _$HeartRateMeasurementDTO {
  factory HeartRateMeasurementDTO({
    required String date,
    required double heartRate,
  }) = _HeartRateMeasurementDTO;

  factory HeartRateMeasurementDTO.fromJson(Map<String, dynamic> json) =>
      _$HeartRateMeasurementDTOFromJson(json);

}