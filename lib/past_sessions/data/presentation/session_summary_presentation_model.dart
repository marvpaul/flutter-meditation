class SessionSummaryPresentationModel {
  final String date;
  final String time;
  final String totalDuration;
  final String maxHeartRate;
  final String minHeartRate;
  final String avgHeartRate;
  final bool isHapticFeedbackEnabled;

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

class SessionSummarySessionPeriodPresentationModel {
  final String periodTitle;
  final String? visualization;
  final double? beatFrequency;
  final String breathingPattern;
  final String breathingPatternMultiplier;
  final String maxHeartRate;
  final String minHeartRate;
  final String avgHeartRate;

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
