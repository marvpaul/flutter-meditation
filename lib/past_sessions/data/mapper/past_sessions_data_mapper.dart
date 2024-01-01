import '../dto/past_sessions_response_dto.dart';
import '../model/past_sessions.dart';

extension PastSessionsResponseDTOMapper on PastSessionsResponseDTO {
  PastSessions? toDomain() {
    if (meditationSessions == null) {
      return null;
    }
    return PastSessions(
      meditationSessions: meditationSessions!.map((dto) => dto.toDomain()).toList(),
    );
  }
}

extension on PastSessionDTO {
  PastSession toDomain() => PastSession(
    date: DateTime.parse(date),
    deviceId: deviceId,
    duration: duration,
    isCanceled: isCanceled,
    isCompleted: isCompleted,
    sessionPeriods: sessionPeriods.map((dto) => dto.toDomain()).toList(),
  );
}

extension on SessionPeriodDTO {
  SessionPeriod toDomain() => SessionPeriod(
    beatFrequency: beatFrequency,
    breathingPattern: breathingPattern.map((dto) => dto.toDomain()).toList(),
    breathingPatternMultiplier: breathingPatternMultiplier,
    heartRateMeasurements: heartRateMeasurements.map((e) => e.toDouble()).toList(),
    isHapticFeedbackEnabled: isHapticFeedbackEnabled,
    visualization: visualization,
  );
}

extension on BreathingPatternDTO {
  BreathingPattern toDomain() => BreathingPattern(
    inhale: inhale,
    hold: hold,
    exhale: exhale,
  );
}
