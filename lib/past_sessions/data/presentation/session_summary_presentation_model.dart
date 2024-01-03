/// {@category Model}
/// Represents a model for summarizing a session.
library session_summary_presentation_model;

class SessionSummaryPresentationModel {
  /// The date of the session.
  final String date;

  /// The time of the session.
  final String time;

  /// The total duration of the session.
  final String totalDuration;

  /// The maximum heart rate during the session.
  final String maxHeartRate;

  /// The minimum heart rate during the session.
  final String minHeartRate;

  /// The average heart rate during the session.
  final String avgHeartRate;

  /// Indicates whether haptic feedback was enabled during the session.
  final bool isHapticFeedbackEnabled;

  /// Creates a [SessionSummaryPresentationModel].
  SessionSummaryPresentationModel({
    required this.date,
    required this.time,
    required this.totalDuration,
    required this.maxHeartRate,
    required this.minHeartRate,
    required this.avgHeartRate,
    required this.isHapticFeedbackEnabled,
  });
}

/// {@category Model}
/// Represents a model for summarizing a session period within a session.
class SessionSummarySessionPeriodPresentationModel {
  /// The title of the session period.
  final String periodTitle;

  /// The visualization used during the session period.
  final String? visualization;

  /// The beat frequency used during the session period.
  final double? beatFrequency;

  /// The breathing pattern used during the session period.
  final String breathingPattern;

  /// The multiplier for the breathing pattern during the session period.
  final String breathingPatternMultiplier;

  /// The maximum heart rate during the session period.
  final String maxHeartRate;

  /// The minimum heart rate during the session period.
  final String minHeartRate;

  /// The average heart rate during the session period.
  final String avgHeartRate;

  /// Creates a [SessionSummarySessionPeriodPresentationModel].
  SessionSummarySessionPeriodPresentationModel({
    required this.periodTitle,
    required this.visualization,
    required this.beatFrequency,
    required this.breathingPattern,
    required this.breathingPatternMultiplier,
    required this.maxHeartRate,
    required this.minHeartRate,
    required this.avgHeartRate,
  });
}
