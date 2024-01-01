
class PastSessions {
  final List<PastSession> meditationSessions;

  PastSessions({required this.meditationSessions});
}

class PastSession {
  final DateTime date;
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
  final List<HeartRateMeasurement> heartRateMeasurements;
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

class HeartRateMeasurement {
  final DateTime date;
  final double heartRate;

  HeartRateMeasurement({
    required this.date,
    required this.heartRate,
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

extension BreathingPatternListExtension on List<BreathingPattern> {
  String toFormattedString() {
    return fold<String>('', (acc, element) {
      String value = '';
      if (element.inhale != null) {
        value = element.inhale.toString();
      } else if (element.hold != null) {
        value = element.hold.toString();
      } else if (element.exhale != null) {
        value = element.exhale.toString();
      }

      // Only append '-' if accumulator is not empty and value is not empty
      if (acc.isNotEmpty && value.isNotEmpty) {
        acc += '-';
      }

      return acc + value;
    });
  }
}



