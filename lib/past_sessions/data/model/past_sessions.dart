import '../dto/past_sessions_response_dto.dart';

class PastSessions {
  final List<PastSession> meditationSessions;

  PastSessions({required this.meditationSessions});
}

class PastSession {
  final String date;
  final String deviceId;
  final int duration;
  final bool isCanceled;
  final bool isCompleted;
  final List<SessionPeriod> sessionPeriods;

  PastSession({
    required this.date,
    required this.deviceId,
    required this.duration,
    required this.isCanceled,
    required this.isCompleted,
    required this.sessionPeriods,
  });
}

class SessionPeriod {
  final double beatFrequency;
  final List<BreathingPattern> breathingPattern;
  final double breathingPatternMultiplier;
  final List<int> heartRateMeasurements;
  final bool isHapticFeedbackEnabled;
  final String visualization;

  SessionPeriod({
    required this.beatFrequency,
    required this.breathingPattern,
    required this.breathingPatternMultiplier,
    required this.heartRateMeasurements,
    required this.isHapticFeedbackEnabled,
    required this.visualization,
  });
}

class BreathingPattern {
  final int? inhale;
  final int? hold;
  final int? exhale;

  BreathingPattern({
    this.inhale,
    this.hold,
    this.exhale,
  });
}
